# Phân tích yêu cầu — vai Consumer

- Cặp đàm phán: Analytics Service ↔ Operator Portal
- Product: Smart Campus
- Consumer service: Operator Portal
- Provider service: Analytics Service
- Người viết: Admin
- Ngày: 2026-05-12

---

## 1. Resource Consumer cần nhận/gửi

| Resource | Consumer dùng để làm gì? | Field bắt buộc với Consumer | Field có thể tùy chọn |
|---|---|---|---|
| IngestEvent | Gửi event từ upstream vào analytics | sourceType, eventId, occurredAt | correlationId, zoneId |
| AnalyticsSummary | Hiển thị số liệu tổng hợp | fromDate, toDate, granularity, totalEvents, totalAlerts, denyRate, generatedAt | topMetric |
| DashboardResponse | Vẽ dashboard | period, generatedAt, cards | note |
| LoginResponse | Lưu token đăng nhập | accessToken, tokenType, expiresInSeconds, user | - |
| Report | Hiển thị report chi tiết | id, title, status, periodStart, periodEnd, generatedAt | description, downloadUrl, sections |

---

## 2. API Consumer cần gọi

| Method | Path | Lúc nào gọi? | Kỳ vọng response |
|---|---|---|---|
| GET | `/health` | Khi kiểm tra hệ thống | `200` với `HealthStatus` |
| POST | `/auth/login` | Khi người dùng đăng nhập | `200` với token |
| POST | `/ingest` | Khi gửi event mới | `202` với `IngestAccepted` |
| GET | `/analytics/summary` | Khi xem KPI | `200` với `AnalyticsSummary` |
| GET | `/dashboard` | Khi mở màn hình tổng quan | `200` với `DashboardResponse` |
| GET | `/reports/{id}` | Khi mở báo cáo | `200` với `Report` |

---

## 3. Error case Consumer cần xử lý

| Status | Consumer hiểu là gì? | Consumer sẽ xử lý thế nào? |
|---:|---|---|
| 400 | Request sai schema | Sửa payload/log lỗi |
| 401 | Thiếu token hoặc token sai | Yêu cầu đăng nhập lại |
| 403 | Không đủ quyền | Báo lỗi quyền truy cập |
| 404 | Không tìm thấy report | Hiển thị trạng thái không tồn tại |
| 422 | Vi phạm rule nghiệp vụ | Hiển thị lý do cụ thể |
| 500 | Lỗi server | Báo lỗi hệ thống và retry hợp lý |

---

## 4. Giả định bổ sung

- Dashboard chỉ cần các card chuẩn hóa, không khóa layout UI cụ thể.
- `sourceType` phải ổn định để consumer map đúng schema khi ingest.
- Report có thể trả `description` hoặc `downloadUrl` là `null` trong một số trạng thái.

---

## 5. Câu hỏi cho Provider

1. `access` và `iot` có phải là toàn bộ giá trị của discriminator không?
2. `granularity` của summary có cho phép mặc định `day` không?
3. `Report.id` có bắt buộc là UUID để consumer lưu cache không?

---

## 6. Rủi ro tích hợp

| Rủi ro | Tác động | Đề xuất xử lý |
|---|---|---|
| Provider đổi field name | Consumer parse lỗi | Chốt schema trong `openapi.yaml` |
| Thiếu `Problem Details` | Debug lỗi khó | Chuẩn hóa `application/problem+json` |
| Event retry gây trùng | Số liệu bị double count | Dùng `eventId` để idempotent |
