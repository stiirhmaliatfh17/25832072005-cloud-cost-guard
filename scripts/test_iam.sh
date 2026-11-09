#!/usr/bin/env bash
# Uji positif dan negatif peran IAM (jalankan di EC2 dengan instance profile). Hasil harus sesuai kolom 'harapan'.
t(){ desc="$1"; shift; out="$("$@" 2>&1)"; rc=$?; echo "[$desc] rc=$rc :: $(echo "$out" | head -c 160 | tr '\n' ' ')"; }
S=$(date -u -d '-7 days' +%F); E=$(date -u +%F)
echo "# $(date -u +%FT%TZ)"
echo "== POSITIF (harapan: rc=0)"
t "ce get-cost-and-usage" aws ce get-cost-and-usage --time-period Start=$S,End=$E --granularity DAILY --metrics UnblendedCost --region us-east-1
echo "== NEGATIF (harapan: AccessDenied)"
t "ec2 describe-instances" aws ec2 describe-instances --region ap-southeast-1
t "ec2 stop-instances" aws ec2 stop-instances --instance-ids i-00000000000000000 --region ap-southeast-1
t "iam list-users" aws iam list-users
t "budgets create-budget" aws budgets create-budget --account-id 000000000000 --budget file:///dev/null
echo "== Cek kebocoran key di repo"
git -C "${REPO:-.}" grep -nE 'AKIA[0-9A-Z]{16}|aws_secret_access_key' || echo "tidak ditemukan"
