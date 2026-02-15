#!/bin/bash

# Sample cURL Commands for Testing Johnny Gabbago Workflow
# Replace YOUR_WEBHOOK_URL with your actual n8n webhook URL

WEBHOOK_URL="YOUR_WEBHOOK_URL"

echo "=========================================="
echo "Johnny Gabbago Video - cURL Test Commands"
echo "=========================================="
echo ""
echo "IMPORTANT: Replace YOUR_WEBHOOK_URL with your actual webhook URL"
echo ""

# Function to print and execute curl commands
run_test() {
  local test_name=$1
  local payload=$2

  echo "----------------------------------------"
  echo "Test: $test_name"
  echo "----------------------------------------"
  echo "Payload:"
  echo "$payload" | python -m json.tool 2>/dev/null || echo "$payload"
  echo ""
  echo "Executing..."

  curl -X POST "$WEBHOOK_URL" \
    -H "Content-Type: application/json" \
    -d "$payload" \
    -w "\n\nHTTP Status: %{http_code}\nTotal Time: %{time_total}s\n"

  echo ""
  echo "----------------------------------------"
  echo ""
}

# Test 1: Birthday Roast
TEST1='{
  "customer_name": "Sarah",
  "recipient_name": "Mike",
  "occasion": "birthday",
  "special_message": "He just turned 40 and is freaking out about getting old",
  "email": "sarah@example.com"
}'

# Test 2: Congratulations
TEST2='{
  "customer_name": "James",
  "recipient_name": "Lisa",
  "occasion": "congratulations",
  "special_message": "She just got promoted to VP after 10 years of hard work",
  "email": "james@example.com"
}'

# Test 3: Motivation
TEST3='{
  "customer_name": "Mom",
  "recipient_name": "Tommy",
  "occasion": "motivation",
  "special_message": "He is 22 and feeling lost after college graduation",
  "email": "mom@example.com"
}'

# Test 4: Advice
TEST4='{
  "customer_name": "Best Friend",
  "recipient_name": "Rachel",
  "occasion": "advice",
  "special_message": "She is thinking about quitting her job to start a business",
  "email": "bestie@example.com"
}'

# Test 5: Celebration
TEST5='{
  "customer_name": "The Team",
  "recipient_name": "David",
  "occasion": "celebration",
  "special_message": "He finally finished his first marathon after training for a year",
  "email": "team@example.com"
}'

# Interactive mode
if [ "$1" == "" ]; then
  echo "Usage: ./sample-curl-commands.sh [test_number|all]"
  echo ""
  echo "Available tests:"
  echo "  1 - Birthday Roast"
  echo "  2 - Congratulations (Career)"
  echo "  3 - Motivation (Life Direction)"
  echo "  4 - Advice (Business Decision)"
  echo "  5 - Celebration (Personal Achievement)"
  echo "  all - Run all tests (warning: will take 15+ minutes)"
  echo ""
  echo "Example: ./sample-curl-commands.sh 1"
  exit 0
fi

# Check if webhook URL is set
if [ "$WEBHOOK_URL" == "YOUR_WEBHOOK_URL" ]; then
  echo "ERROR: Please edit this file and replace YOUR_WEBHOOK_URL with your actual webhook URL"
  exit 1
fi

# Run selected test
case "$1" in
  1)
    run_test "Birthday Roast (40th)" "$TEST1"
    ;;
  2)
    run_test "Congratulations (Promotion)" "$TEST2"
    ;;
  3)
    run_test "Motivation (Lost Graduate)" "$TEST3"
    ;;
  4)
    run_test "Advice (Career Change)" "$TEST4"
    ;;
  5)
    run_test "Celebration (Marathon)" "$TEST5"
    ;;
  all)
    echo "Running all tests... This will take 15+ minutes!"
    echo ""
    run_test "Birthday Roast (40th)" "$TEST1"
    sleep 5
    run_test "Congratulations (Promotion)" "$TEST2"
    sleep 5
    run_test "Motivation (Lost Graduate)" "$TEST3"
    sleep 5
    run_test "Advice (Career Change)" "$TEST4"
    sleep 5
    run_test "Celebration (Marathon)" "$TEST5"
    echo "All tests completed!"
    ;;
  *)
    echo "Invalid test number. Use: 1, 2, 3, 4, 5, or 'all'"
    exit 1
    ;;
esac

echo "=========================================="
echo "Test Complete"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Check the response JSON for video_url"
echo "2. Review execution logs in n8n"
echo "3. Download and watch the generated video"
echo ""
