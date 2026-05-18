import { NextRequest, NextResponse } from "next/server";
import Anthropic from "@anthropic-ai/sdk";
import { createClient } from "@supabase/supabase-js";

const anthropic = new Anthropic({ apiKey: process.env.ANTHROPIC_API_KEY });

async function translateText(text: string): Promise<string> {
  const msg = await anthropic.messages.create({
    model: "claude-haiku-4-5-20251001",
    max_tokens: 1024,
    messages: [
      {
        role: "user",
        content: `Translate the following to Indonesian (Bahasa Indonesia). Keep the same tone and style. Only return the translated text, no explanation.\n\n${text}`,
      },
    ],
  });
  return (msg.content[0] as { type: string; text: string }).text?.trim() ?? "";
}

// POST /api/translate-quiz  { moduleId: string }  — translate one module's quiz
// GET  /api/translate-quiz                         — backfill all untranslated quiz content
export async function POST(req: NextRequest) {
  try {
    const { moduleId } = await req.json();
    if (!moduleId) return NextResponse.json({ ok: false, error: "moduleId required" }, { status: 400 });

    const supabase = createClient(
      process.env.NEXT_PUBLIC_SUPABASE_URL!,
      process.env.SUPABASE_SERVICE_ROLE_KEY!
    );

    const [{ data: questions }, { data: options }] = await Promise.all([
      supabase.from("quiz_questions").select("id, question_text, question_text_id").eq("course_module_id", moduleId),
      supabase.from("quiz_options").select("id, option_text, option_text_id, question_id"),
    ]);

    // Filter options that belong to this module's questions
    const questionIds = new Set((questions ?? []).map((q: { id: string }) => q.id));
    const moduleOptions = (options ?? []).filter((o: { question_id: string }) => questionIds.has(o.question_id));

    let translated = 0;

    // Translate questions missing Indonesian
    for (const q of (questions ?? []) as { id: string; question_text: string; question_text_id: string | null }[]) {
      if (q.question_text_id) continue;
      const text = await translateText(q.question_text);
      if (text) {
        await supabase.from("quiz_questions").update({ question_text_id: text }).eq("id", q.id);
        translated++;
      }
    }

    // Translate options missing Indonesian
    for (const o of moduleOptions as { id: string; option_text: string; option_text_id: string | null }[]) {
      if (o.option_text_id) continue;
      const text = await translateText(o.option_text);
      if (text) {
        await supabase.from("quiz_options").update({ option_text_id: text }).eq("id", o.id);
        translated++;
      }
    }

    return NextResponse.json({ ok: true, translated });
  } catch (err) {
    return NextResponse.json({ ok: false, error: String(err) }, { status: 500 });
  }
}

export async function GET() {
  try {
    const supabase = createClient(
      process.env.NEXT_PUBLIC_SUPABASE_URL!,
      process.env.SUPABASE_SERVICE_ROLE_KEY!
    );

    // Fetch all untranslated questions and options
    const [{ data: questions }, { data: options }] = await Promise.all([
      supabase.from("quiz_questions").select("id, question_text, question_text_id").is("question_text_id", null).not("question_text", "is", null),
      supabase.from("quiz_options").select("id, option_text, option_text_id").is("option_text_id", null).not("option_text", "is", null),
    ]);

    let translated = 0;
    let failed = 0;

    for (const q of (questions ?? []) as { id: string; question_text: string }[]) {
      try {
        const text = await translateText(q.question_text);
        if (text) {
          await supabase.from("quiz_questions").update({ question_text_id: text }).eq("id", q.id);
          translated++;
        }
      } catch { failed++; }
    }

    for (const o of (options ?? []) as { id: string; option_text: string }[]) {
      try {
        const text = await translateText(o.option_text);
        if (text) {
          await supabase.from("quiz_options").update({ option_text_id: text }).eq("id", o.id);
          translated++;
        }
      } catch { failed++; }
    }

    return NextResponse.json({
      ok: true,
      translated,
      failed,
      questions: questions?.length ?? 0,
      options: options?.length ?? 0,
    });
  } catch (err) {
    return NextResponse.json({ ok: false, error: String(err) }, { status: 500 });
  }
}
