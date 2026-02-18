import os
import json
import urllib.request
import urllib.error
import boto3

sns = boto3.client("sns")

def handler(event, context):
    url = os.environ["CHECK_URL"]
    topic_arn = os.environ["SNS_TOPIC_ARN"]
    timeout = int(os.environ.get("TIMEOUT_SECONDS", "5"))

    try:
        req = urllib.request.Request(url, headers={"User-Agent": "aws-uptime-monitor"})
        with urllib.request.urlopen(req, timeout=timeout) as resp:
            status = resp.getcode()

        msg = f"UP ✅ {url} returned HTTP {status}"
        print(msg)
        return {"ok": True, "status": status, "message": msg}

    except Exception as e:
        msg = f"DOWN ❌ {url} check failed: {str(e)}"
        print(msg)

        sns.publish(
            TopicArn=topic_arn,
            Subject="Uptime Monitor Alert: DOWN",
            Message=msg
        )

        return {"ok": False, "error": str(e), "message": msg}
