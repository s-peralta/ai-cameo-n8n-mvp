# Testing Guide - Johnny Gabbago Workflow

Complete guide for testing your AI video workflow with sample data and debugging tips.

## Quick Test Checklist

Before running tests:
- [ ] Workflow is imported and saved
- [ ] API credentials are configured (Anthropic & HeyGen)
- [ ] Workflow is **activated** (toggle is green)
- [ ] Webhook URL is copied and ready
- [ ] You have `curl` or Postman installed

---

## Test Method 1: Manual Test in n8n (Recommended for First Test)

### Step 1: Enable Test Mode

1. Open the workflow in n8n editor
2. Click on the **"Webhook - Video Request"** node
3. Click **"Listen for Test Event"**
4. You'll see "Waiting for webhook call..." status

### Step 2: Send Test Request

Open a terminal and run:

```bash
curl -X POST YOUR_WEBHOOK_URL \
  -H "Content-Type: application/json" \
  -d '{
    "customer_name": "Sarah",
    "recipient_name": "Mike",
    "occasion": "birthday",
    "special_message": "He just turned 40 and is freaking out about getting old",
    "email": "sarah@example.com"
  }'
```

**Replace `YOUR_WEBHOOK_URL`** with your actual webhook URL from the Webhook node.

### Step 3: Watch Execution

- In n8n, you'll see each node execute in real-time
- Green = success, Red = error
- Click on any node to see its input/output data
- Total execution time: 1-3 minutes

### Step 4: Review Results

Click on the **"Respond - Success"** node to see:

```json
{
  "video_url": "https://heygen.com/videos/abc123xyz",
  "status": "completed",
  "script_used": "Ey Mike, it's your pal Johnny Gabbago here...",
  "generation_time_seconds": 142,
  "customer_email": "sarah@example.com"
}
```

---

## Test Method 2: Production Webhook Test

Once the workflow is activated, test the production endpoint:

### Using cURL

```bash
curl -X POST https://your-production-webhook-url \
  -H "Content-Type: application/json" \
  -d '{
    "customer_name": "Test",
    "recipient_name": "Alex",
    "occasion": "motivation",
    "special_message": "Starting a new business",
    "email": "test@example.com"
  }'
```

### Using Postman

1. **Create new request**
   - Method: `POST`
   - URL: Your webhook URL
   - Headers: `Content-Type: application/json`

2. **Body (raw JSON)**
   ```json
   {
     "customer_name": "Test",
     "recipient_name": "Alex",
     "occasion": "motivation",
     "special_message": "Starting a new business",
     "email": "test@example.com"
   }
   ```

3. **Send**
   - Click "Send"
   - Wait 1-3 minutes for response
   - Status should be 200 OK

### Using JavaScript/Node.js

```javascript
const axios = require('axios');

async function orderVideo() {
  try {
    const response = await axios.post('YOUR_WEBHOOK_URL', {
      customer_name: 'Test',
      recipient_name: 'Alex',
      occasion: 'motivation',
      special_message: 'Starting a new business',
      email: 'test@example.com'
    });

    console.log('Video generated:', response.data);
    return response.data;
  } catch (error) {
    console.error('Error:', error.response?.data || error.message);
  }
}

orderVideo();
```

---

## Sample Test Payloads

### Test 1: Birthday Roast (Milestone)

```json
{
  "customer_name": "Sarah",
  "recipient_name": "Mike",
  "occasion": "birthday",
  "special_message": "He just turned 40 and is freaking out about getting old. He used to be the cool guy, now he complains about his back.",
  "email": "sarah@example.com"
}
```

**Expected Script Theme**: Humorous roast about aging, but encouraging about embracing the next chapter.

---

### Test 2: Congratulations (New Job)

```json
{
  "customer_name": "James",
  "recipient_name": "Lisa",
  "occasion": "congratulations",
  "special_message": "She just got promoted to VP after 10 years of hard work. She almost gave up last year but pushed through.",
  "email": "james@example.com"
}
```

**Expected Script Theme**: Enthusiastic praise, acknowledgment of perseverance, encouragement to keep climbing.

---

### Test 3: Motivational Pep Talk

```json
{
  "customer_name": "Mom",
  "recipient_name": "Tommy",
  "occasion": "motivation",
  "special_message": "He's 22 and feeling lost after college graduation. Not sure what to do with his life. Needs a kick in the pants.",
  "email": "mom@example.com"
}
```

**Expected Script Theme**: Tough love about finding direction, but supportive about the journey.

---

### Test 4: Advice Request

```json
{
  "customer_name": "Best Friend",
  "recipient_name": "Rachel",
  "occasion": "advice",
  "special_message": "She's thinking about quitting her stable job to start a business. Scared but excited. Needs some real talk.",
  "email": "bestie@example.com"
}
```

**Expected Script Theme**: Honest assessment of risks, encouragement to trust her gut, practical wisdom.

---

### Test 5: Generic Celebration

```json
{
  "customer_name": "The Team",
  "recipient_name": "David",
  "occasion": "celebration",
  "special_message": "He finally finished his first marathon after training for a year. It was brutal but he did it!",
  "email": "team@example.com"
}
```

**Expected Script Theme**: Big celebration of achievement, acknowledgment of hard work, pride.

---

## Expected Response Formats

### Success Response (200 OK)

```json
{
  "video_url": "https://resource.heygen.com/video/abc123xyz.mp4",
  "status": "completed",
  "script_used": "Ey Mike, it's your pal Johnny Gabbago here. Listen, I heard you just hit the big 4-0 and you're having a little crisis...",
  "generation_time_seconds": 142,
  "customer_email": "sarah@example.com"
}
```

### Timeout Response (202 Accepted)

If video takes longer than 3 minutes:

```json
{
  "status": "timeout",
  "error": "Video generation timed out after 3 minutes. Video may still be processing.",
  "video_id": "abc123xyz"
}
```

**What to do**: Check HeyGen dashboard with the `video_id` to see if video completed.

### Error Response (400/500)

```json
{
  "error": "Missing required field: recipient_name",
  "status": "error"
}
```

---

## Debugging Common Issues

### Issue: "Webhook not found" (404)

**Symptoms**: `curl` returns 404 error

**Diagnosis**:
- Workflow is not activated
- Wrong webhook URL
- Webhook path doesn't match

**Fix**:
1. Ensure workflow toggle is **green** (activated)
2. Copy webhook URL directly from the Webhook node
3. Check for typos in the URL

---

### Issue: "Invalid JSON" (400)

**Symptoms**: "Unexpected token" or "Invalid JSON" error

**Diagnosis**:
- JSON syntax error in payload
- Missing quotes or commas
- Special characters not escaped

**Fix**:
```bash
# Validate JSON first
echo '{your-json}' | python -m json.tool

# Or use a JSON validator online
```

---

### Issue: Claude API Error (401/429)

**Symptoms**: Node shows error: "Authentication failed" or "Rate limit exceeded"

**Diagnosis**:
- API key invalid or expired
- No credits in Anthropic account
- Too many requests (rate limited)

**Fix**:
1. Verify API key in n8n credentials
2. Check Anthropic console for account status
3. Wait 60 seconds if rate limited
4. Add credits to account if depleted

**Test Claude API directly**:
```bash
curl https://api.anthropic.com/v1/messages \
  -H "x-api-key: YOUR_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -H "content-type: application/json" \
  -d '{"model": "claude-sonnet-4-20250514", "max_tokens": 10, "messages": [{"role": "user", "content": "hi"}]}'
```

---

### Issue: HeyGen API Error (401/402)

**Symptoms**: "Invalid API key" or "Payment required"

**Diagnosis**:
- HeyGen API key invalid
- No credits in HeyGen account
- Account suspended

**Fix**:
1. Verify API key in n8n credentials
2. Check HeyGen dashboard for credits
3. Add credits or upgrade plan

**Test HeyGen API directly**:
```bash
curl https://api.heygen.com/v1/user.get \
  -H "X-Api-Key: YOUR_KEY"
```

---

### Issue: Video Generation Timeout

**Symptoms**: Workflow returns 202 timeout response after 3 minutes

**Diagnosis**:
- Video is taking longer than expected (normal for long scripts)
- HeyGen service slowdown
- Network connectivity issues

**Fix**:
1. **Check HeyGen dashboard** manually with the `video_id` returned
2. **Increase polling duration**:
   - Edit "Check Retry Limit" node
   - Change condition from `< 18` to `< 30` (5 minutes total)
3. **Shorten the script** if consistently timing out

---

### Issue: Script Doesn't Sound Like Johnny

**Symptoms**: Generated script is generic or off-character

**Diagnosis**:
- System prompt needs refinement
- Temperature too low/high
- Input details too vague

**Fix**:
1. Review the script in execution logs
2. Adjust system prompt in "Claude - Generate Script" node
3. Provide more specific details in `special_message` field
4. Adjust `temperature` (current: 0.7)
   - Lower (0.5) = more consistent, less creative
   - Higher (0.9) = more creative, less predictable

---

### Issue: Video Has No Audio or Wrong Voice

**Symptoms**: Video plays but no sound, or voice doesn't match

**Diagnosis**:
- HeyGen voice_id is invalid
- Script has no text
- Audio encoding issue

**Fix**:
1. Check HeyGen dashboard for available voices
2. Update `voice_id` in "HeyGen - Start Video Generation" node
3. See `docs/heygen-avatar-setup.md` for voice options

---

## Monitoring and Logs

### View Execution History

1. Go to **"Executions"** in n8n sidebar
2. See list of all workflow runs
3. Filter by:
   - Status (success/error)
   - Date range
   - Execution time

### Understanding Execution Logs

Each execution shows:
- **Start time**: When webhook was triggered
- **Duration**: Total execution time
- **Status**: Success (green) or Error (red)
- **Node details**: Click any node to see input/output

### Useful Log Data

**Claude Script Output**:
- Navigate to "Extract Script" node
- See `script` field with full generated text
- Copy for review or reuse

**HeyGen Video ID**:
- Navigate to "Extract Video ID" node
- See `video_id` field
- Use to check status in HeyGen dashboard

**Generation Time**:
- Navigate to "Format Success Response" node
- See `generation_time_seconds` field
- Track performance over time

---

## Performance Benchmarks

### Expected Timing

| Stage | Duration |
|-------|----------|
| Webhook to Claude | < 1 second |
| Claude script generation | 2-5 seconds |
| HeyGen video submission | 1-2 seconds |
| Video generation | 60-120 seconds |
| Polling overhead | 10-30 seconds |
| **Total** | **90-180 seconds** |

### What's Normal

- ✅ 1.5-2.5 minutes total = Great
- ✅ 2.5-3.5 minutes = Normal
- ⚠️ 3.5-5 minutes = Slow but okay
- ❌ > 5 minutes = Issue (check HeyGen)

---

## Load Testing

### Testing Multiple Requests

**Not recommended**: Sending parallel requests without queuing will:
- Hit rate limits
- Exhaust HeyGen concurrent video limit (10)
- Increase costs unnecessarily

**Recommended approach**:
1. Test one request at a time initially
2. Wait for completion before sending next
3. For production load testing, implement a queue system

### Stress Test Script

```bash
#!/bin/bash
WEBHOOK_URL="your-webhook-url"

for i in {1..5}; do
  echo "Sending request $i..."
  curl -X POST $WEBHOOK_URL \
    -H "Content-Type: application/json" \
    -d "{
      \"customer_name\": \"Tester\",
      \"recipient_name\": \"User$i\",
      \"occasion\": \"test\",
      \"special_message\": \"Test request $i\",
      \"email\": \"test$i@example.com\"
    }" &

  # Wait 30 seconds between requests
  sleep 30
done

wait
echo "All requests sent"
```

---

## Validation Rules

### Required Fields

All fields are required:
- `customer_name` (string, 1-100 chars)
- `recipient_name` (string, 1-100 chars)
- `occasion` (string, e.g., "birthday", "motivation")
- `special_message` (string, 10-500 chars)
- `email` (string, valid email format)

### Recommended Occasions

- `birthday`
- `congratulations`
- `motivation`
- `advice`
- `celebration`
- `encouragement`
- `pep-talk`

(Any string works, but these are optimized)

---

## Next Steps After Testing

Once tests are passing:

1. ✅ **Document your webhook URL** for frontend integration
2. ✅ **Set up error notifications** (n8n email alerts)
3. ✅ **Implement frontend form** to collect customer data
4. ✅ **Add payment processing** (Stripe integration)
5. ✅ **Set up email delivery** (send video link to customer)
6. ✅ **Monitor costs** (track Claude & HeyGen usage)
7. ✅ **Customize avatar** (see `heygen-avatar-setup.md`)

---

## Troubleshooting Checklist

Before asking for help, verify:

- [ ] Workflow is activated (green toggle)
- [ ] Both API credentials are configured correctly
- [ ] API keys are valid and have credits
- [ ] Webhook URL is correct (no typos)
- [ ] JSON payload is valid (use validator)
- [ ] n8n execution logs show detailed error
- [ ] Tested with sample payloads from this guide
- [ ] Waited full 3 minutes for video generation

---

**Happy testing!** If everything is working, you're ready to customize and deploy.

*"Now go out there and make me proud, capisce?" - Johnny*
