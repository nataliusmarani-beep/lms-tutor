import { NextResponse } from "next/server";
import Anthropic from "@anthropic-ai/sdk";
import { createClient } from "@/lib/supabase/server";

const anthropic = new Anthropic({ apiKey: process.env.ANTHROPIC_API_KEY });

export async function GET() {
  try {
    const supabase = createClient();

    // Fetch all sessions with tutor_notes but no translation yet
    const { data: sessions, error } = await supabase
      .from("learning_sessions")
      .select("id, tutor_notes")
      .not("tutor_notes", "is", null)
      .is("tutor_notes_id", null);

    if (error) return NextResponse.json({ ok: false, error: error.message }, { status: 500 });
    if (!sessions || sessions.length === 0) {
      return NextResponse.json({ ok: true, message: "Nothing to translate." });
    }

    let translated = 0;
    let failed = 0;

    for (const s of sessions) {
      try {
        const msg = await anthropic.messages.create({
          model: "claude-haiku-4-5-20251001",
          max_tokens: 1024,
          messages: [
            {
              role: "user",
              content: `Translate the following tutor session notes to Indonesian (Bahasa Indonesia). Keep the same structure and tone. Only return the translated text, no explanation.\n\n${s.tutor_notes}`,
            },
          ],
        });

        const text = (msg.content[0] as { type: string; text: string }).text?.trim();
        if (text) {
          await supabase
            .from("learning_sessions")
            .update({ tutor_notes_id: text })
            .eq("id", s.id);
          translated++;
        }
      } catch {
        failed++;
      }
    }

    return NextResponse.json({ ok: true, translated, failed, total: sessions.length });
  } catch (err) {
    return NextResponse.json({ ok: false, error: String(err) }, { status: 500 });
  }
}
