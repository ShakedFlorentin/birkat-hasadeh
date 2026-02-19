import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

serve(async (req) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const {
      order_number,
      customer_name,
      customer_phone,
      delivery_type,
      delivery_address,
      total_amount,
      notes,
    } = await req.json();

    // Create Supabase client with service role key to read settings
    const supabase = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
    );

    // Read WhatsApp/Twilio settings from store_settings
    const { data: settings, error: settingsErr } = await supabase
      .from("store_settings")
      .select("setting_key, setting_value")
      .in("setting_key", [
        "whatsapp_enabled",
        "whatsapp_phone",
        "twilio_account_sid",
        "twilio_auth_token",
        "twilio_whatsapp_from",
      ]);

    if (settingsErr) {
      console.error("Failed to read settings:", settingsErr);
      return new Response(
        JSON.stringify({ success: false, error: "Failed to read settings" }),
        { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Build settings map
    const cfg: Record<string, string> = {};
    for (const row of settings || []) {
      cfg[row.setting_key] = row.setting_value;
    }

    // Guard: skip if not enabled or missing credentials
    if (
      cfg.whatsapp_enabled !== "true" ||
      !cfg.whatsapp_phone ||
      !cfg.twilio_account_sid ||
      !cfg.twilio_auth_token ||
      !cfg.twilio_whatsapp_from
    ) {
      return new Response(
        JSON.stringify({ success: true, skipped: true, reason: "WhatsApp not enabled or missing credentials" }),
        { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Build Hebrew message
    const deliveryLine =
      delivery_type === "delivery"
        ? `🚗 משלוח: ${delivery_address || ""}`
        : "📍 איסוף עצמי";

    let message =
      `🛒 הזמנה חדשה #${order_number}\n` +
      `👤 ${customer_name}\n` +
      `📱 ${customer_phone}\n` +
      `${deliveryLine}\n` +
      `💰 סה"כ: ${total_amount}₪`;

    if (notes) {
      message += `\n📝 ${notes}`;
    }

    // Strip non-digits from phone numbers
    const toPhone = cfg.whatsapp_phone.replace(/[^0-9]/g, "");
    const fromPhone = cfg.twilio_whatsapp_from.replace(/[^0-9]/g, "");

    // Call Twilio API
    const sid = cfg.twilio_account_sid;
    const token = cfg.twilio_auth_token;
    const twilioUrl = `https://api.twilio.com/2010-04-01/Accounts/${sid}/Messages.json`;

    const body = new URLSearchParams({
      From: `whatsapp:+${fromPhone}`,
      To: `whatsapp:+${toPhone}`,
      Body: message,
    });

    const twilioRes = await fetch(twilioUrl, {
      method: "POST",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        Authorization: "Basic " + btoa(`${sid}:${token}`),
      },
      body: body.toString(),
    });

    const twilioData = await twilioRes.json();

    if (!twilioRes.ok) {
      console.error("Twilio error:", twilioData);
      return new Response(
        JSON.stringify({ success: false, error: twilioData.message || "Twilio API error" }),
        { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    console.log("WhatsApp sent:", twilioData.sid);
    return new Response(
      JSON.stringify({ success: true, message_sid: twilioData.sid }),
      { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  } catch (err) {
    console.error("Edge function error:", err);
    return new Response(
      JSON.stringify({ success: false, error: err.message }),
      { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
