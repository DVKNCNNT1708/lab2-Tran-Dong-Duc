# Evidence Buổi 02

Thư mục này lưu bằng chứng Lab 02.

Cần có:

```text
evidence/buoi-02/
  README.md
  checklist.md
  known-issues.md
  spectral-report.txt
  tool-versions.txt
  git-log.txt
  mock-screenshots/
    req-01-health.png
    req-02-login.png
    req-03-ingest.png
    req-04-summary.png
    req-05-error.png
```

## Cách sinh report Spectral

```bash
./scripts/collect_session02_evidence.sh
```

Windows:

```powershell
.\scripts\collect_session02_evidence.ps1
```

## Ảnh mock server

Lab 02 chưa yêu cầu Postman. Minh chứng nên là ảnh chụp Terminal/PowerShell khi chạy `curl` tới Prism mock server.

Nên chụp theo thứ tự:

1. `GET /health` trả `200`.
2. `POST /auth/login` trả `200`.
3. `POST /ingest` trả `202`.
4. `GET /analytics/summary` trả `200`.
5. `POST /auth/login` thiếu `password` hoặc `POST /ingest` payload sai trả `422`.

Mỗi ảnh cần thể hiện:

- lệnh `curl` trong Terminal/PowerShell;
- status code;
- response body;
- URL `http://localhost:4010/...`.
