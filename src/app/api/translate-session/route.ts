import { NextRequest, NextResponse } from "next/server";
import Anthropic from "@anthropic-ai/sdk";
import { createClient } from "@supabase/supabase-js";

const anthropic = new Anthropic({ apiKey: process.env.ANTHROPIC_API_KEY });

export async function POST(req: NextRequest) {
  try {
    const { sessionId, tutor_notes } = await req.json();
    if (!sessionId || !tutor_notes?.trim()) {
      return NextResponse.json({ ok: true, skipped: true });
    }

    // Translate to Indonesian
    const msg = await anthropic.messages.create({
      model: "claude-haiku-4-5-20251001",
      max_tokens: 1024,
      messages: [
        {
          role: "user",
          content: `Translate the following tutor session notes to Indonesian (Bahasa Indonesia). Keep the same structure and tone. Only return the translated text, no explanation.\n\n${tutor_notes}`,
        },
      ],
    });

    const translated = (msg.content[0] as { type: string; text: string }).text?.trim();
    if (!translated) return NextResponse.json({ ok: true, skipped: true });

    // Save translation back to the session using service role to bypass RLS
    const supabase = createClient(
      process.env.NEXT_PUBLIC_SUPABASE_URL!,
      process.env.SUPABASE_SERVICE_ROLE_KEY!
    );
    const { error } = await supabase
      .from("learning_sessions")
      .update({ tutor_notes_id: translated })
      .eq("id", sessionId);

    if (error) {
      console.error("translate-session update error:", error);
      return NextResponse.json({ ok: false, error: error.message }, { status: 500 });
    }

    return NextResponse.json({ ok: true, translated });
  } catch (err) {
    console.error("translate-session error:", err);
    return NextResponse.json({ ok: false, error: String(err) }, { status: 500 });
  }
}
