# Setup Guide - Johnny Gabbago AI Cameo MVP

Complete step-by-step guide to get your Johnny Gabbago video automation running in under 30 minutes.

## Prerequisites

Before starting, ensure you have:

- [ ] **n8n installed** (version 0.200.0 or later)
  - Self-hosted: [Installation guide](https://docs.n8n.io/hosting/installation/)
  - Cloud: [n8n Cloud account](https://app.n8n.cloud/)
- [ ] **Anthropic API key**
  - Sign up at [console.anthropic.com](https://console.anthropic.com/)
  - Navigate to API Keys section
  - Create a new key with appropriate credits
- [ ] **HeyGen API key**
  - Use provided key: `sk_V2_hgu_k8qbby2q941_YRun3wPe2mLRZ2FDl7Qx90tNrl4OemGS`
  - Or create your own at [HeyGen](https://www.heygen.com/)

## Step 1: Install n8n (if not already installed)

### Option A: Self-Hosted with npm

```bash
# Install n8n globally
npm install n8n -g

# Start n8n
n8n start

# Access at http://localhost:5678
```

### Option B: Self-Hosted with Docker

```bash
# Run n8n in Docker
docker run -it --rm \
  --name n8n \
  -p 5678:5678 \
  -v ~/.n8n:/home/node/.n8n \
  n8nio/n8n

# Access at http://localhost:5678
```

### Option C: n8n Cloud

1. Go to [app.n8n.cloud](https://app.n8n.cloud/)
2. Sign up for an account
3. Your instance will be ready in minutes

## Step 2: Import the Workflow

1. **Open n8n**
   - Navigate to your n8n instance (http://localhost:5678 or your cloud URL)
   - Log in if required

2. **Import the workflow file**
   - Click **"Workflows"** in the left sidebar
   - Click the **"+"** button or **"Add Workflow"**
   - Click the **"⋯"** (three dots) menu in the top right
   - Select **"Import from File"**
   - Choose `workflows/johnny-gabbago-workflow.json` from this project
   - Click **"Import"**

3. **Verify import**
   - You should see a workflow named "Johnny Gabbago AI Cameo MVP"
   - The workflow should have multiple nodes connected in a flow
   - Don't worry about red warnings yet - we'll add credentials next

## Step 3: Configure API Credentials

### 3.1 Add Anthropic (Claude) API Credentials

1. **Open credentials manager**
   - Click **"Credentials"** in the left sidebar (or navigate via Settings)
   - Click **"Add Credential"**

2. **Create Anthropic credential**
   - Search for **"Header Auth"** or **"HTTP Header Auth"**
   - Click on it
   - Fill in the following:
     - **Name**: `Anthropic API Key`
     - **Header Name**: `x-api-key`
     - **Header Value**: `YOUR_ANTHROPIC_API_KEY` (paste your actual key)
   - Click **"Save"**

### 3.2 Add HeyGen API Credentials

1. **Create HeyGen credential**
   - Click **"Add Credential"** again
   - Search for **"Header Auth"** or **"HTTP Header Auth"**
   - Click on it
   - Fill in the following:
     - **Name**: `HeyGen API Key`
     - **Header Name**: `X-Api-Key`
     - **Header Value**: `sk_V2_hgu_k8qbby2q941_YRun3wPe2mLRZ2FDl7Qx90tNrl4OemGS`
   - Click **"Save"**

## Step 4: Connect Credentials to Workflow

1. **Open the workflow**
   - Go back to "Workflows"
   - Click on "Johnny Gabbago AI Cameo MVP"

2. **Connect Anthropic credential**
   - Click on the **"Claude - Generate Script"** node
   - In the node settings, find **"Credential for Header Auth"**
   - Select **"Anthropic API Key"** from the dropdown
   - Click outside the node or press **"Execute Node"** to test

3. **Connect HeyGen credentials**
   - Click on the **"HeyGen - Start Video Generation"** node
   - In the node settings, find **"Credential for Header Auth"**
   - Select **"HeyGen API Key"** from the dropdown
   - Repeat for **"Check Video Status"** node

4. **Save the workflow**
   - Click the **"Save"** button in the top right
   - You should see "Workflow saved" confirmation

## Step 5: Activate the Workflow

1. **Enable the workflow**
   - Toggle the **"Active"** switch in the top right (should turn green)
   - This makes the webhook available to receive requests

2. **Copy the webhook URL**
   - Click on the **"Webhook - Video Request"** node
   - Click **"Copy Production URL"** button
   - Save this URL - you'll need it for testing!
   - Example: `https://your-n8n-instance.com/webhook/johnny-gabbago-video`

## Step 6: Test the Workflow

### Quick Test (Manual Execution)

1. **In the workflow editor**
   - Click on the **"Webhook - Video Request"** node
   - Click the **"Listen for Test Event"** button
   - The node will show "Waiting for webhook call..."

2. **Send a test request**
   - Open a new terminal
   - Run the following curl command (replace URL with your webhook URL):

```bash
curl -X POST https://your-webhook-url \
  -H "Content-Type: application/json" \
  -d '{
    "customer_name": "Sarah",
    "recipient_name": "Mike",
    "occasion": "birthday",
    "special_message": "He just turned 40 and is freaking out",
    "email": "sarah@example.com"
  }'
```

3. **Watch the execution**
   - In n8n, you'll see the workflow execute step by step
   - Each node will light up as it processes
   - The entire flow takes 1-3 minutes (mostly video generation time)

4. **Check the result**
   - Look at the final response node
   - You should see JSON with `video_url`, `status`, `script_used`, etc.

### Production Test

Once the workflow is active, you can test the production webhook:

```bash
curl -X POST https://your-production-webhook-url \
  -H "Content-Type: application/json" \
  -d '{
    "customer_name": "Test User",
    "recipient_name": "Johnny",
    "occasion": "motivation",
    "special_message": "Starting a new business and feeling nervous",
    "email": "test@example.com"
  }'
```

## Step 7: Review Execution Logs

1. **View executions**
   - Click **"Executions"** in the left sidebar
   - You'll see a list of all workflow runs
   - Click on any execution to see detailed logs

2. **Debug issues**
   - Red nodes indicate errors
   - Click on a node to see error details
   - Common issues:
     - Invalid API keys → Check credentials
     - Timeout errors → HeyGen may be slow, increase wait time
     - JSON parsing errors → Check webhook payload format

## Troubleshooting Common Setup Issues

### Issue: "Workflow not found" after import

**Solution:**
- Make sure the JSON file is valid
- Try copying the JSON content and pasting it directly via "Import from URL or Text"

### Issue: "Credential not found" errors

**Solution:**
- Ensure credential names match exactly: `Anthropic API Key` and `HeyGen API Key`
- Check that credentials are saved before assigning to nodes
- Try recreating the credentials if they're not appearing

### Issue: Claude API returns 401 Unauthorized

**Solution:**
- Verify your Anthropic API key is correct
- Check that your Anthropic account has available credits
- Ensure the header name is exactly `x-api-key` (lowercase)

### Issue: HeyGen API returns errors

**Solution:**
- Verify the API key is correct
- Check HeyGen account status and quotas
- Ensure the script text isn't too long (max ~500 words)

### Issue: Webhook returns 404

**Solution:**
- Make sure the workflow is **activated** (toggle is green)
- Check that you're using the production URL, not test URL
- Verify the webhook path matches in your request

### Issue: Video generation times out

**Solution:**
- This is normal for longer videos (can take 2-3 minutes)
- The workflow polls for up to 3 minutes (18 retries × 10 seconds)
- If it times out, the video may still complete - check HeyGen dashboard

## Next Steps

Now that your workflow is running:

1. **Test with different scenarios** - Try the examples in `examples/test-payloads.json`
2. **Customize the character** - See `docs/heygen-avatar-setup.md`
3. **Set up monitoring** - Configure n8n error notifications
4. **Review the script output** - Refine Johnny's personality in the Claude prompt
5. **Add integrations** - Connect to Stripe, email delivery, etc.

## Security Best Practices

- [ ] **Never commit API keys** - Use n8n credentials system only
- [ ] **Enable webhook authentication** - In webhook node settings, enable basic auth
- [ ] **Set up HTTPS** - For production, always use SSL/TLS
- [ ] **Limit execution time** - Set reasonable timeouts to avoid runaway costs
- [ ] **Monitor usage** - Track API costs for Claude and HeyGen
- [ ] **Backup workflows** - Export workflow JSON regularly

## Support

If you encounter issues:

1. Check execution logs in n8n
2. Review the troubleshooting section above
3. Verify API keys and credentials
4. Test individual nodes using "Execute Node" button
5. Check [n8n community forum](https://community.n8n.io/)

---

**You're all set!** Your Johnny Gabbago AI video automation is ready to create personalized videos.

*"Now go out there and make me proud, capisce?" - Johnny*
