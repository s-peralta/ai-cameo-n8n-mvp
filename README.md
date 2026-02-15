# Johnny Gabbago AI Cameo MVP

**Automated personalized video messages from Johnny Gabbago - your Brooklyn motivational speaker with heart.**

## 🎯 What This Does

This n8n workflow creates personalized AI-generated video messages from Johnny Gabbago, a streetwise Brooklyn motivational speaker with Italian-American charm. Customers submit a request via webhook, and the system automatically:

1. Generates a custom script using Claude AI (perfectly in Johnny's voice)
2. Creates a personalized video using HeyGen's avatar technology
3. Returns the video URL ready to share

## ✨ Features

- **Fully Automated**: Webhook to video in under 3 minutes
- **Personalized Scripts**: Claude AI writes unique messages for each recipient
- **Professional Video**: HeyGen generates high-quality avatar videos
- **Multiple Use Cases**: Birthdays, congratulations, motivation, advice, celebrations
- **Production Ready**: Complete error handling and retry logic
- **Easy Setup**: Import workflow and add API keys - done in 30 minutes

## 🚀 Quick Start

### Prerequisites

- [n8n](https://n8n.io/) installed (self-hosted or cloud)
- Anthropic Claude API key
- HeyGen API key (provided: `sk_V2_hgu_k8qbby2q941_YRun3wPe2mLRZ2FDl7Qx90tNrl4OemGS`)

### Installation

1. **Import the workflow**
   - Open n8n
   - Go to Workflows → Import
   - Select `workflows/johnny-gabbago-workflow.json`

2. **Configure API credentials**
   - Follow [`docs/api-configuration.md`](docs/api-configuration.md)
   - Add your Anthropic API key
   - HeyGen key is pre-configured (or use your own)

3. **Activate the workflow**
   - Click "Activate" in n8n
   - Copy your webhook URL

4. **Test it**
   - Use the test payloads in `examples/test-payloads.json`
   - Follow [`docs/testing-guide.md`](docs/testing-guide.md)

## 📚 Documentation

- [**Setup Guide**](docs/setup-guide.md) - Step-by-step installation
- [**API Configuration**](docs/api-configuration.md) - Setting up credentials
- [**Testing Guide**](docs/testing-guide.md) - How to test the workflow
- [**HeyGen Avatar Setup**](docs/heygen-avatar-setup.md) - Customizing avatar and voice

## 🎭 Meet Johnny Gabbago

Johnny is a Brooklyn-born motivational speaker who combines tough love with genuine warmth. Think Tony Soprano meets life coach - he'll roast you with love and motivate you through no-nonsense wisdom.

**Signature Style:**
- Opens with: "Ey [name], it's your pal Johnny Gabbago here"
- Uses phrases like "listen kid," "capisce," "fuggedaboutit"
- Ends with: "Now go out there and make me proud, capisce?"

**Perfect For:**
- Birthday roasts (especially milestone birthdays)
- Congratulations messages
- Motivational pep talks
- Life advice
- Generic celebrations

## 🧪 Testing

Test with the included sample payloads:

```bash
# Birthday roast example
curl -X POST https://your-n8n-webhook-url \
  -H "Content-Type: application/json" \
  -d '{
    "customer_name": "Sarah",
    "recipient_name": "Mike",
    "occasion": "birthday",
    "special_message": "He just turned 40 and is freaking out about getting old",
    "email": "sarah@example.com"
  }'
```

See `examples/sample-curl-commands.sh` for more examples.

## 📊 Workflow Overview

```
Webhook Trigger
    ↓
Claude API (Script Generation)
    ↓
HeyGen API (Video Generation)
    ↓
Poll Video Status (until complete)
    ↓
Return Video URL
```

**Expected Response:**
```json
{
  "video_url": "https://heygen.com/videos/abc123",
  "status": "completed",
  "script_used": "Ey Mike, it's your pal Johnny Gabbago...",
  "generation_time": "142 seconds"
}
```

## 🔐 Security

- All API keys stored in n8n credentials (encrypted)
- No sensitive data logged
- Webhook can be password-protected in n8n settings
- See `config/api-keys.example.env` for environment variable setup

## 🛠️ Technical Stack

- **n8n**: Workflow automation
- **Claude Sonnet 4**: Script generation (natural language AI)
- **HeyGen**: Video avatar generation
- **Webhook**: RESTful API endpoint

## 📈 Next Steps / Future Enhancements

- [ ] Add payment integration (Stripe)
- [ ] Email delivery of completed videos
- [ ] Multiple character personalities
- [ ] Custom avatar uploads
- [ ] Video preview before delivery
- [ ] Analytics dashboard
- [ ] Customer dashboard for order history

## 🐛 Troubleshooting

**Workflow not triggering:**
- Check webhook URL is correct
- Ensure workflow is activated
- Verify JSON payload format

**Claude API errors:**
- Verify API key is valid
- Check Anthropic account has credits
- Review rate limits

**HeyGen video generation fails:**
- Check API key is valid
- Verify HeyGen account status
- Review script length (max 500 words)

**Video generation times out:**
- Increase polling timeout in workflow settings
- Check HeyGen service status
- Verify network connectivity

## 💬 Support

For issues or questions:
1. Check the documentation in `docs/`
2. Review troubleshooting section above
3. Check n8n workflow execution logs
4. Verify API credentials are correct

## 📝 License

MIT License - feel free to modify and use for your projects

## 🙏 Credits

- **Character Creation**: Johnny Gabbago personality design
- **AI**: Anthropic Claude for script generation
- **Video**: HeyGen avatar technology
- **Automation**: n8n workflow platform

---

**Built with ❤️ for creating personalized AI video messages**

*"Now go out there and make me proud, capisce?" - Johnny Gabbago*
