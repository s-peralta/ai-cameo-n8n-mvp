# HeyGen Avatar & Voice Setup Guide

Complete guide for customizing the avatar appearance and voice in your Johnny Gabbago videos.

## Overview

The workflow currently uses HeyGen's default avatar and voice. This guide shows how to:
1. Browse available avatars
2. Select a specific avatar for Johnny Gabbago
3. Customize voice selection
4. Adjust video settings (background, dimensions, etc.)

---

## Understanding HeyGen Avatars

### What are Avatars?

HeyGen avatars are AI-generated characters that:
- Lip-sync to any text script
- Support multiple languages
- Have realistic facial expressions
- Can be customized for appearance and voice

### Avatar Types

1. **Default Avatars** - Pre-made characters provided by HeyGen
2. **Custom Avatars** - Create your own from uploaded videos (requires Pro plan)
3. **Studio Avatars** - Professional actors (requires Enterprise plan)

---

## Finding Available Avatars

### Method 1: HeyGen Dashboard

1. Log into [heygen.com](https://www.heygen.com/)
2. Go to **"Avatars"** section
3. Browse the avatar library
4. Click on any avatar to see:
   - Avatar ID (e.g., `avatar_12345`)
   - Preview video
   - Available poses/styles
   - Supported voices

### Method 2: HeyGen API

Get list of avatars via API:

```bash
curl https://api.heygen.com/v1/avatar.list \
  -H "X-Api-Key: YOUR_HEYGEN_API_KEY"
```

**Response example**:
```json
{
  "code": 100,
  "data": {
    "avatars": [
      {
        "avatar_id": "josh_lite3_20230714",
        "avatar_name": "Josh - Casual",
        "gender": "male",
        "preview_image_url": "https://...",
        "preview_video_url": "https://..."
      },
      {
        "avatar_id": "anna_public_3_20240108",
        "avatar_name": "Anna - Professional",
        "gender": "female",
        "preview_image_url": "https://...",
        "preview_video_url": "https://..."
      }
    ]
  }
}
```

---

## Recommended Avatars for Johnny Gabbago

Based on the character (Brooklyn Italian-American motivational speaker):

### Option 1: Male Casual Avatar
- **Avatar ID**: `josh_lite3_20230714`
- **Style**: Casual, relatable
- **Best for**: Friendly pep talks

### Option 2: Male Professional Avatar
- **Avatar ID**: `wayne_20240711`
- **Style**: Mature, authoritative
- **Best for**: Serious advice, life coaching

### Option 3: Male Business Casual
- **Avatar ID**: `eric_public_2_20230608`
- **Style**: Mix of professional and approachable
- **Best for**: Balanced tone (our recommendation)

**Note**: Avatar IDs may change. Always verify in your HeyGen dashboard.

---

## Updating Avatar in Workflow

### Step 1: Find the HeyGen Node

1. Open the workflow in n8n
2. Find the **"HeyGen - Start Video Generation"** node
3. Click to open node settings

### Step 2: Modify Avatar ID

In the JSON Body field, find:

```json
"character": {
  "type": "avatar",
  "avatar_id": "default",
  "avatar_style": "normal"
}
```

**Replace `"default"` with your chosen avatar ID**:

```json
"character": {
  "type": "avatar",
  "avatar_id": "eric_public_2_20230608",
  "avatar_style": "normal"
}
```

### Step 3: Save and Test

1. Click outside the node or press "Execute Node"
2. Test the workflow with a sample payload
3. Verify the avatar looks right in the output video

---

## Voice Selection

### Understanding HeyGen Voices

Each avatar can use:
- **Avatar's default voice** (recommended for most consistent results)
- **Custom voice from voice library**
- **Cloned voice** (requires Pro/Enterprise plan)

### Finding Available Voices

```bash
curl https://api.heygen.com/v1/voice.list \
  -H "X-Api-Key: YOUR_HEYGEN_API_KEY"
```

**Response includes**:
- Voice ID
- Voice name
- Language
- Gender
- Preview audio URL

### Recommended Voices for Johnny Gabbago

Look for:
- **Gender**: Male
- **Age**: Middle-aged (40-60)
- **Accent**: American English, ideally with character
- **Tone**: Warm but authoritative

**Popular choices**:
- `voice_2f8c3b9a` - "Marcus" (deep, authoritative)
- `voice_7d91ba3e` - "Tony" (warm, friendly)
- `voice_5e8d9c2f` - "Vincent" (mature, wise)

### Updating Voice in Workflow

In the **"HeyGen - Start Video Generation"** node, modify:

```json
"voice": {
  "type": "text",
  "input_text": "{{ $json.script }}",
  "voice_id": "default"
}
```

**Change to specific voice**:

```json
"voice": {
  "type": "text",
  "input_text": "{{ $json.script }}",
  "voice_id": "voice_2f8c3b9a"
}
```

**For avatar's default voice, use**:

```json
"voice": {
  "type": "text",
  "input_text": "{{ $json.script }}",
  "voice_id": "default"
}
```

---

## Voice Settings & Parameters

### Speed

Control how fast the avatar speaks:

```json
"voice": {
  "type": "text",
  "input_text": "{{ $json.script }}",
  "voice_id": "default",
  "speed": 1.0
}
```

- `0.5` = Half speed (slow)
- `1.0` = Normal speed (default)
- `1.5` = 1.5x speed (fast)
- Range: `0.5` to `1.5`

**Recommendation for Johnny**: `1.0` or `1.05` (slightly upbeat)

### Pitch

Adjust voice pitch (if supported):

```json
"voice": {
  "type": "text",
  "input_text": "{{ $json.script }}",
  "voice_id": "default",
  "pitch": 0
}
```

- Negative values = Lower pitch
- Positive values = Higher pitch
- Range: `-10` to `+10`

---

## Background Customization

### Solid Color Background

Current default (white):

```json
"background": {
  "type": "color",
  "value": "#FFFFFF"
}
```

**Options for Johnny**:
- **Warm gray**: `#F5F5F5`
- **Soft blue**: `#E8F4F8`
- **Subtle beige**: `#FFF8E7`
- **Dark gray**: `#2D2D2D` (for dramatic effect)

### Image Background

Use a custom background image:

```json
"background": {
  "type": "image",
  "url": "https://your-domain.com/backgrounds/office.jpg"
}
```

**Recommendations**:
- Office setting
- Urban/city background
- Blurred bokeh effect
- Neutral tones to avoid distraction

### Video Background

Use a looping video as background:

```json
"background": {
  "type": "video",
  "url": "https://your-domain.com/backgrounds/office-loop.mp4"
}
```

---

## Video Dimensions & Quality

### Standard Dimensions

Current workflow uses 1080p widescreen:

```json
"dimension": {
  "width": 1920,
  "height": 1080
},
"aspect_ratio": "16:9"
```

### Alternative Formats

**720p (faster, cheaper)**:
```json
"dimension": {
  "width": 1280,
  "height": 720
},
"aspect_ratio": "16:9"
```

**Vertical video (mobile/social)**:
```json
"dimension": {
  "width": 1080,
  "height": 1920
},
"aspect_ratio": "9:16"
```

**Square (social media)**:
```json
"dimension": {
  "width": 1080,
  "height": 1080
},
"aspect_ratio": "1:1"
```

---

## Advanced Features

### Subtitles/Captions

Enable closed captions:

```json
"caption": true
```

**Caption settings**:
```json
"caption": {
  "enabled": true,
  "position": "bottom",
  "font_size": 24,
  "font_color": "#FFFFFF",
  "background_color": "#000000",
  "background_opacity": 0.7
}
```

### Test Mode

Generate free preview (watermarked):

```json
"test": true
```

**When to use**:
- Testing new avatars
- Previewing script changes
- Before spending credits

**Important**: Set to `false` for production videos!

---

## Creating Custom Avatar (Advanced)

### Requirements

- HeyGen Pro or Enterprise plan
- 2-5 minute video of the person
- Good lighting and audio
- Consent from the person

### Process

1. **Record video**
   - Film person speaking naturally
   - Multiple angles/poses
   - Clear pronunciation
   - Follow HeyGen guidelines

2. **Upload to HeyGen**
   - Go to "Create Avatar" in dashboard
   - Upload video
   - Processing takes 24-48 hours

3. **Get Avatar ID**
   - Once approved, get the `avatar_id`
   - Update workflow with new ID

4. **Test thoroughly**
   - Generate test videos
   - Check lip-sync quality
   - Verify voice match

---

## Best Practices

### Avatar Selection

✅ **Do**:
- Choose avatar that matches character personality
- Test multiple avatars before deciding
- Consider your target audience
- Use consistent avatar across all videos

❌ **Don't**:
- Use avatars with very distinct appearances (unless intentional)
- Change avatars frequently (confuses customers)
- Use avatars that don't match voice tone

### Voice Selection

✅ **Do**:
- Match voice to character personality
- Test voice with sample scripts
- Ensure voice is clear and understandable
- Consider accent preferences of target audience

❌ **Don't**:
- Use voices that sound robotic
- Mismatch gender/age with avatar
- Use extremely fast or slow speeds
- Choose voices with heavy accents unless intentional

### Background Selection

✅ **Do**:
- Keep backgrounds simple and professional
- Use colors that complement avatar
- Ensure good contrast (avatar stands out)
- Test on different devices/screens

❌ **Don't**:
- Use busy or distracting backgrounds
- Have poor contrast (avatar blends in)
- Use low-quality images
- Change backgrounds randomly between videos

---

## Testing Avatar Changes

### Quick Test Workflow

1. Update avatar/voice settings in workflow
2. Use this minimal test payload:

```json
{
  "customer_name": "Test",
  "recipient_name": "Test",
  "occasion": "test",
  "special_message": "Testing new avatar and voice settings",
  "email": "test@example.com"
}
```

3. Execute workflow in test mode (`"test": true`)
4. Review watermarked preview
5. If satisfied, set `"test": false` for production

---

## Troubleshooting

### Issue: "Invalid avatar_id"

**Fix**:
- Verify avatar ID is correct (check HeyGen dashboard)
- Ensure avatar is available in your plan tier
- Try using `"default"` to confirm workflow works

### Issue: Avatar doesn't look right

**Fix**:
- Check avatar preview in HeyGen dashboard first
- Verify avatar supports your selected voice
- Test with different poses/styles

### Issue: Voice doesn't match avatar

**Fix**:
- Use avatar's default voice for best match
- Check voice preview before using
- Ensure voice gender matches avatar

### Issue: Poor lip-sync quality

**Fix**:
- Use avatar's default voice (best sync)
- Ensure script has proper punctuation
- Avoid very long sentences (break them up)
- Check script for unusual characters

---

## Cost Considerations

### Avatar Costs

- **Default avatars**: Included in standard pricing
- **Premium avatars**: May cost extra credits
- **Custom avatars**: One-time creation fee + standard usage

### Optimization Tips

- Use 720p instead of 1080p to save credits (if quality acceptable)
- Enable test mode for previews (free, but watermarked)
- Reuse successful avatar/voice combinations
- Batch similar videos together

---

## Recommended Setup for Johnny Gabbago

Based on character requirements:

```json
{
  "video_inputs": [
    {
      "character": {
        "type": "avatar",
        "avatar_id": "eric_public_2_20230608",
        "avatar_style": "normal"
      },
      "voice": {
        "type": "text",
        "input_text": "{{ $json.script }}",
        "voice_id": "default",
        "speed": 1.05
      },
      "background": {
        "type": "color",
        "value": "#F5F5F5"
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

**Why this setup**:
- Professional but approachable avatar
- Natural voice speed (slightly upbeat)
- Neutral background (focus on message)
- High quality for professional delivery
- No captions (clean, personal feel)

---

## Next Steps

1. Browse HeyGen avatar library
2. Test 2-3 avatars with sample scripts
3. Select the best match for Johnny's personality
4. Update workflow with chosen avatar_id
5. Test production videos
6. Gather feedback from test customers
7. Fine-tune voice/background as needed

---

## Additional Resources

- **HeyGen Avatar Guide**: [docs.heygen.com/avatars](https://docs.heygen.com/docs/avatars)
- **Voice Library**: [app.heygen.com/voices](https://app.heygen.com/voices)
- **Custom Avatar FAQ**: [help.heygen.com/custom-avatars](https://help.heygen.com/)

---

**Ready to bring Johnny Gabbago to life!** 🎥

*"Now go out there and make me proud, capisce?" - Johnny*
