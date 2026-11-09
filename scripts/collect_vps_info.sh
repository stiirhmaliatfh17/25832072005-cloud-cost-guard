#!/usr/bin/env bash
# Inventaris VPS (ev01). Keluaran tidak memuat secret; tetap periksa sebelum dipublikasikan.
OUT="${1:-ev01-output-$(date -u +%Y%m%dT%H%M%SZ).txt}"
{
echo "# Waktu (UTC): $(date -u +%FT%TZ)"
echo "# Host: $(hostname)"
echo '## os-release'; cat /etc/os-release
echo '## nproc'; nproc
echo '## free -h'; free -h
echo '## lsblk'; lsblk
echo '## df -h /'; df -h /
echo '## ss -lnt'; ss -lnt
echo '## ufw'; sudo ufw status verbose
echo '## instance-type (IMDSv2)'
T=$(curl -s -m 3 -X PUT http://169.254.169.254/latest/api/token -H "X-aws-ec2-metadata-token-ttl-seconds: 60")
curl -s -m 3 -H "X-aws-ec2-metadata-token: $T" http://169.254.169.254/latest/meta-data/instance-type; echo
curl -s -m 3 -H "X-aws-ec2-metadata-token: $T" http://169.254.169.254/latest/meta-data/placement/region; echo
} 2>&1 | tee "$OUT"
