import { NextRequest, NextResponse } from "next/server";
import Anthropic from "@anthropic-ai/sdk";
import { createClient } from "@supabase/supabase-js";

const anthropic = new Anthropic({ apiKey: process.env.ANTHROPIC_API_KEY });

async function translateDescription(text: string): Promise<string> {
  const msg = await anthropic.messages.create({
    model: "claude-haiku-4-5-20251001",
    max_tokens: 1024,
    messages: [
      {
        role: "user",
        content: `Translate the following course description to Indonesian (Bahasa Indonesia). Keep the same tone and structure. Only return the translated text, no explanation.\n\n${text}`,
      },
    ],
  });
  return (msg.content[0] as { type: string; text: string }).text?.trim() ?? "";
}

// GET — backfill all courses missing description_id
export async function GET() {
  try {
    const supabase = createClient(
      process.env.NEXT_PUBLIC_SUPABASE_URL!,
      process.env.SUPABASE_SERVICE_ROLE_KEY!
    );

    const { data: courses, error } = await supabase
      .from("courses")
      .select("id, description")
      .not("description", "is", null)
      .is("description_id", null);

    if (error) return NextResponse.json({ ok: false, error: error.message }, { status: 500 });
    if (!courses || courses.length === 0) {
      return NextResponse.json({ ok: true, message: "Nothing to translate." });
    }

    let translated = 0;
    let failed = 0;

    for (const course of courses) {
      try {
        const text = await translateDescription(course.description as string);
        if (text) {
          await supabase.from("courses").update({ description_id: text }).eq("id", course.id);
          translated++;
        }
      } catch (e) {
        console.error("Translation failed for course", course.id, e);
        failed++;
      }
    }

    return NextResponse.json({ ok: true, translated, failed, total: courses.length });
  } catch (err) {
    return NextResponse.json({ ok: false, error: String(err) }, { status: 500 });
  }
}

// POST — translate a single course description and save it
export async function POST(req: NextRequest) {
  try {
    const { courseId, description } = await req.json();
    if (!courseId || !description?.trim()) {
      return NextResponse.json({ ok: true, skipped: true });
    }

    const translated = await translateDescription(description);
    if (!translated) return NextResponse.json({ ok: true, skipped: true });

    const supabase = createClient(
      process.env.NEXT_PUBLIC_SUPABASE_URL!,
      process.env.SUPABASE_SERVICE_ROLE_KEY!
    );
    const { error } = await supabase
      .from("courses")
      .update({ description_id: translated })
      .eq("id", courseId);

    if (error) return NextResponse.json({ ok: false, error: error.message }, { status: 500 });

    return NextResponse.json({ ok: true, translated });
  } catch (err) {
    return NextResponse.json({ ok: false, error: String(err) }, { status: 500 });
  }
}
