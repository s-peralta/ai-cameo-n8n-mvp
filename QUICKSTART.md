# ⚡ Quick Start - Johnny Gabbago AI Cameo

Get your AI video workflow running in **under 10 minutes**.

## Prerequisites

- [ ] n8n installed ([Download](https://n8n.io/download))
- [ ] Anthropic API key ([Get one](https://console.anthropic.com/))
- [ ] HeyGen API key (Use provided or [get your own](https://heygen.com/))

## 5-Step Setup

### 1. Import Workflow (2 minutes)

1. Open n8n → **Workflows** → **Import from File**
2. Select: `workflows/johnny-gabbago-workflow.json`
3. Click **Import**

### 2. Add API Credentials (3 minutes)

**Anthropic (Claude):**
1. n8n → **Credentials** → **Add Credential** → **HTTP Header Auth**
2. Name: `Anthropic API Key`
3. Header Name: `x-api-key`
4. Header Value: `[your Anthropic key]`
5. Save

**HeyGen:**
1. n8n → **Credentials** → **Add Credential** → **HTTP Header Auth**
2. Name: `HeyGen API Key`
3. Header Name: `X-Api-Key`
4. Header Value: `sk_V2_hgu_k8qbby2q941_YRun3wPe2mLRZ2FDl7Qx90tNrl4OemGS`
5. Save

### 3. Connect Credentials (2 minutes)

1. Open the workflow in n8n
2. Click **"Claude - Generate Script"** node → Select **"Anthropic API Key"**
3. Click **"HeyGen - Start Video Generation"** node → Select **"HeyGen API Key"**
4. Click **"Check Video Status"** node → Select **"HeyGen API Key"**
5. **Save** workflow

### 4. Activate Workflow (1 minute)

1. Toggle **Active** switch (top right) to **ON** (green)
2. Click **"Webhook - Video Request"** node
3. Copy the **Production URL**
4. Save it - you'll need this!

### 5. Test It! (2 minutes)

Open terminal and run:

```bash
curl -X POST YOUR_WEBHOOK_URL \
  -H "Content-Type: application/json" \
  -d '{
    "customer_name": "Test User",
    "recipient_name": "Johnny",
    "occasion": "motivation",
    "special_message": "Starting a new business and feeling nervous",
    "email": "test@example.com"
  }'
```

Replace `YOUR_WEBHOOK_URL` with the URL from Step 4.

**Wait 1-3 minutes**, then you'll get:

```json
{
  "video_url": "https://heygen.com/videos/abc123",
  "status": "completed",
  "script_used": "Ey Johnny, it's your pal Johnny Gabbago here...",
  "generation_time_seconds": 142
}
```

**Open the `video_url` in your browser to watch!** 🎉

---

## Troubleshooting

**Webhook returns 404?**
→ Make sure workflow is **activated** (toggle is green)

**Claude API error?**
→ Check your Anthropic API key has credits

**Video times out?**
→ Normal for first request. Check HeyGen dashboard with `video_id`

---

## Next Steps

✅ **Working?** Great! Now:

1. Try different test payloads from `examples/test-payloads.json`
2. Customize Johnny's avatar: See `docs/heygen-avatar-setup.md`
3. Integrate with your frontend/app
4. Add payment processing (Stripe)
5. Set up email delivery

📚 **Full Documentation**: See [`README.md`](README.md) for complete guides

---

## Need Help?

- **Setup Issues**: See [`docs/setup-guide.md`](docs/setup-guide.md)
- **API Problems**: See [`docs/api-configuration.md`](docs/api-configuration.md)
- **Testing**: See [`docs/testing-guide.md`](docs/testing-guide.md)

---

**That's it! You're ready to generate personalized AI videos.** 🚀

*"Now go out there and make me proud, capisce?" - Johnny Gabbago*
