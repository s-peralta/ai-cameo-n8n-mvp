# API Configuration Guide

Detailed guide for setting up and managing API credentials for the Johnny Gabbago workflow.

## Overview

The workflow requires two API credentials:

1. **Anthropic Claude API** - For generating personalized scripts
2. **HeyGen API** - For creating avatar videos

Both are configured using n8n's credential system for security and reusability.

---

## Anthropic Claude API Setup

### Getting Your API Key

1. **Sign up for Anthropic**
   - Go to [console.anthropic.com](https://console.anthropic.com/)
   - Create an account or log in
   - Navigate to **API Keys** section

2. **Create a new API key**
   - Click **"Create Key"**
   - Give it a descriptive name (e.g., "Johnny Gabbago n8n")
   - Copy the key immediately (you won't see it again!)
   - Example format: `sk-ant-api03-xxxxxxxxxxxx`

3. **Add credits (if needed)**
   - Go to **Billing** section
   - Add payment method
   - Purchase credits or set up auto-reload
   - Recommended starting amount: $20 (lasts for ~400 videos at current pricing)

### Configuring in n8n

1. **Create HTTP Header Auth credential**
   - In n8n, go to **Credentials**
   - Click **"Add Credential"**
   - Search for **"Header Auth"**
   - Select **"HTTP Header Auth"**

2. **Enter credential details**
   ```
   Name: Anthropic API Key
   Header Name: x-api-key
   Header Value: [paste your API key here]
   ```

3. **Save and test**
   - Click **"Save"**
   - The credential is now available for HTTP Request nodes

### API Specifications

- **Base URL**: `https://api.anthropic.com/v1/messages`
- **Authentication**: Header-based (`x-api-key`)
- **Model**: `claude-sonnet-4-20250514`
- **Rate Limits**:
  - 50 requests per minute (free tier)
  - 1000 requests per minute (paid tier)
- **Pricing** (as of February 2026):
  - Input: ~$3 per million tokens
  - Output: ~$15 per million tokens
  - Average cost per video script: ~$0.05

### Required Headers

```json
{
  "x-api-key": "your-api-key",
  "anthropic-version": "2023-06-01",
  "Content-Type": "application/json"
}
```

### Request Body Structure

```json
{
  "model": "claude-sonnet-4-20250514",
  "max_tokens": 500,
  "temperature": 0.7,
  "system": "[Johnny Gabbago personality prompt]",
  "messages": [
    {
      "role": "user",
      "content": "[Personalization details]"
    }
  ]
}
```

### Response Structure

```json
{
  "id": "msg_xxx",
  "type": "message",
  "role": "assistant",
  "content": [
    {
      "type": "text",
      "text": "Ey Mike, it's your pal Johnny Gabbago here..."
    }
  ],
  "model": "claude-sonnet-4-20250514",
  "stop_reason": "end_turn",
  "usage": {
    "input_tokens": 150,
    "output_tokens": 200
  }
}
```

### Troubleshooting Claude API

**Error: 401 Unauthorized**
- API key is invalid or expired
- Check that key starts with `sk-ant-api03-`
- Regenerate key in Anthropic console

**Error: 429 Too Many Requests**
- Rate limit exceeded
- Wait 60 seconds and retry
- Upgrade to paid tier for higher limits

**Error: 400 Bad Request**
- Check JSON body structure
- Verify `anthropic-version` header is included
- Ensure `max_tokens` is reasonable (100-1000)

**Error: 500 Internal Server Error**
- Anthropic service issue (rare)
- Retry with exponential backoff
- Check [status.anthropic.com](https://status.anthropic.com)

---

## HeyGen API Setup

### Getting Your API Key

**Option 1: Use Provided Key**
```
sk_V2_hgu_k8qbby2q941_YRun3wPe2mLRZ2FDl7Qx90tNrl4OemGS
```

**Option 2: Create Your Own**
1. Go to [heygen.com](https://www.heygen.com/)
2. Sign up for an account
3. Navigate to **API** section in dashboard
4. Click **"Generate API Key"**
5. Copy the key (format: `sk_V2_xxxx`)

### Pricing Information

- **Free Trial**: Usually 1-5 credits for testing
- **Paid Plans**:
  - Creator: $24/month (15 video credits)
  - Business: $120/month (90 video credits)
  - Enterprise: Custom pricing
- **Average cost per video**: $0.80 - $1.50 depending on length

### Configuring in n8n

1. **Create HTTP Header Auth credential**
   - In n8n, go to **Credentials**
   - Click **"Add Credential"**
   - Search for **"Header Auth"**
   - Select **"HTTP Header Auth"**

2. **Enter credential details**
   ```
   Name: HeyGen API Key
   Header Name: X-Api-Key
   Header Value: [paste your HeyGen API key]
   ```

3. **Save**
   - Click **"Save"**
   - This credential will be used in two nodes:
     - "HeyGen - Start Video Generation"
     - "Check Video Status"

### API Specifications

- **Base URL**: `https://api.heygen.com`
- **Authentication**: Header-based (`X-Api-Key`)
- **Video Generation Endpoint**: `POST /v2/video/generate`
- **Status Check Endpoint**: `GET /v1/video_status.get?video_id={id}`
- **Rate Limits**:
  - 10 concurrent video generations
  - 100 API calls per minute

### Required Headers

```json
{
  "X-Api-Key": "your-heygen-api-key",
  "Content-Type": "application/json"
}
```

### Video Generation Request Body

```json
{
  "video_inputs": [
    {
      "character": {
        "type": "avatar",
        "avatar_id": "default",
        "avatar_style": "normal"
      },
      "voice": {
        "type": "text",
        "input_text": "Your script here",
        "voice_id": "default"
      },
      "background": {
        "type": "color",
        "value": "#FFFFFF"
      }
    }
  ],
  "dimension": {
    "width": 1920,
    "height": 1080
  },
  "aspect_ratio": "16:9",
  "test": false,
  "caption": false
}
```

### Video Generation Response

```json
{
  "code": 100,
  "data": {
    "video_id": "abc123xyz789"
  },
  "message": "Success"
}
```

### Video Status Response

```json
{
  "code": 100,
  "data": {
    "video_id": "abc123xyz789",
    "status": "completed",
    "video_url": "https://heygen.com/videos/abc123",
    "thumbnail_url": "https://heygen.com/thumbnails/abc123.jpg",
    "duration": 65.5
  },
  "message": "Success"
}
```

### Status Values

- `pending` - Video is queued
- `processing` - Video is being generated
- `completed` - Video is ready (includes video_url)
- `failed` - Generation failed (check error message)

### Troubleshooting HeyGen API

**Error: 401 Unauthorized**
- API key is invalid
- Check that header name is `X-Api-Key` (capital X)
- Verify key format: `sk_V2_xxxx`

**Error: 402 Payment Required**
- HeyGen account has no credits
- Add credits or upgrade plan
- Check billing dashboard

**Error: 400 Bad Request - Invalid avatar_id**
- The avatar ID doesn't exist
- Use `"default"` for testing
- See `docs/heygen-avatar-setup.md` for available avatars

**Error: 429 Too Many Requests**
- Exceeded rate limit (10 concurrent videos)
- Wait for existing videos to complete
- Implement queuing system for high volume

**Video stuck in "processing" status**
- Normal for 60-120 seconds
- The workflow polls for up to 3 minutes
- Check HeyGen dashboard for status
- If > 5 minutes, contact HeyGen support

**Video generation fails with no error**
- Script may be too long (max ~500 words)
- Check for special characters that break TTS
- Try with a shorter test script

---

## Security Best Practices

### Protecting API Keys

1. **Never hardcode keys in workflow JSON**
   - Always use n8n credentials system
   - Keys are encrypted at rest

2. **Use environment variables for self-hosted**
   ```bash
   # In your .env file
   ANTHROPIC_API_KEY=sk-ant-api03-xxx
   HEYGEN_API_KEY=sk_V2_xxx
   ```

3. **Rotate keys periodically**
   - Generate new keys every 90 days
   - Update in n8n credentials
   - Revoke old keys

4. **Monitor usage**
   - Set up billing alerts in Anthropic console
   - Track HeyGen credit usage
   - Watch for unusual spikes

5. **Restrict key permissions**
   - Use separate keys for dev/prod
   - Limit key scopes if available
   - Never share keys via email/chat

### Rate Limiting

Implement rate limiting to avoid excessive costs:

1. **In n8n workflow**
   - Add rate limiter node if available
   - Limit to X requests per hour

2. **At API level**
   - Configure max spending in Anthropic console
   - Set HeyGen account spending limits

3. **Application level**
   - Implement queuing for bulk requests
   - Cache generated scripts for similar requests

---

## Cost Estimation

### Per Video Cost Breakdown

| Service | Operation | Cost |
|---------|-----------|------|
| Claude API | Script generation | ~$0.05 |
| HeyGen API | Video generation | ~$1.00 |
| **Total per video** | | **~$1.05** |

### Monthly Cost Examples

| Volume | Claude Cost | HeyGen Cost | Total |
|--------|-------------|-------------|-------|
| 10 videos | $0.50 | $10 | $10.50 |
| 100 videos | $5 | $100 | $105 |
| 1,000 videos | $50 | $1,000 | $1,050 |

**Note**: Actual costs vary based on:
- Script length (affects Claude tokens)
- Video length (affects HeyGen credits)
- Plan tier and volume discounts

---

## Testing Credentials

### Test Claude API

```bash
curl https://api.anthropic.com/v1/messages \
  -H "x-api-key: YOUR_API_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -H "content-type: application/json" \
  -d '{
    "model": "claude-sonnet-4-20250514",
    "max_tokens": 100,
    "messages": [{"role": "user", "content": "Say hello"}]
  }'
```

### Test HeyGen API

```bash
# Check account status
curl https://api.heygen.com/v1/user.get \
  -H "X-Api-Key: YOUR_API_KEY"
```

---

## Additional Resources

- **Anthropic Documentation**: [docs.anthropic.com](https://docs.anthropic.com/)
- **HeyGen API Docs**: [docs.heygen.com](https://docs.heygen.com/)
- **n8n Credentials Guide**: [docs.n8n.io/credentials](https://docs.n8n.io/credentials/)

---

**Next Steps**: See [`testing-guide.md`](testing-guide.md) to test your configured workflow.
