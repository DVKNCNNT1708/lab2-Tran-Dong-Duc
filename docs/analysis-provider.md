# Phân tích yêu cầu — vai Provider

- Cặp đàm phán: Analytics Service ↔ Operator Portal
- Product: Smart Campus
- Provider service: Analytics Service
- Consumer service: Operator Portal
- Người viết: Admin
- Ngày: 2026-05-12

---

## 1. Resource chính

| Resource | Mô tả | Thuộc tính bắt buộc | Thuộc tính tùy chọn |
|---|---|---|---|
| HealthStatus | Trạng thái service | status, service, time | - |
| IngestEvent | Event đầu vào cho analytics | sourceType, eventId, occurredAt | correlationId, zoneId |
| AnalyticsSummary | KPI tổng hợp theo khoảng thời gian | fromDate, toDate, granularity, totalEvents, totalAlerts, denyRate, generatedAt | topMetric |
| DashboardResponse | Dữ liệu cho màn hình dashboard | period, generatedAt, cards | note |
| Report | Báo cáo chi tiết theo id | id, title, status, periodStart, periodEnd, generatedAt | description, downloadUrl, sections |

---

## 2. Action/API dự kiến

| Method | Path | Mục đích | Consumer gọi khi nào? |
|---|---|---|---|
| GET | `/health` | Kiểm tra service còn sống | Khi startup hoặc health check |
| POST | `/auth/login` | Lấy token truy cập | Khi user mở ứng dụng |
| POST | `/ingest` | Nhận event từ upstream | Khi có access/iot event mới |
| GET | `/analytics/summary` | Lấy KPI tổng hợp | Khi cần số liệu dashboard |
| GET | `/dashboard` | Lấy dữ liệu màn hình chính | Khi mở dashboard |
| GET | `/reports/{id}` | Lấy báo cáo chi tiết | Khi người dùng mở report |

---

## 3. Error case

| Status | Tình huống | Response body dự kiến |
|---:|---|---|
| 400 | Payload sai định dạng hoặc thiếu field bắt buộc | `Problem` |
| 401 | Thiếu hoặc sai token | `Problem` |
| 403 | Token hợp lệ nhưng không đủ quyền | `Problem` |
| 404 | Report không tồn tại | `Problem` |
| 422 | JSON hợp lệ nhưng vi phạm rule nghiệp vụ | `Problem` |
| 500 | Lỗi xử lý nội bộ hoặc downstream | `Problem` |

---

## 4. Giả định bổ sung

- `POST /ingest` trả `202 Accepted` vì analytics xử lý bất đồng bộ.
- `sourceType` là discriminator chính để phân biệt event `access` và `iot`.
- `correlationId` được cho phép `null` để hỗ trợ nguồn upstream chưa phát sinh trace id.

---

## 5. Câu hỏi cho Consumer

1. Dashboard cần `granularity` mặc định là `day` hay `hour`?
2. Có cần buộc `correlationId` luôn có giá trị không?
3. Report có cần chuẩn hóa `downloadUrl` ngay từ Lab 02 không?

---

## 6. Rủi ro tích hợp

| Rủi ro | Tác động | Đề xuất xử lý |
|---|---|---|
| Consumer gửi event khác discriminator | Prism/mock hoặc parser lỗi | Chốt `sourceType` trong contract |
| Query window không rõ | Summary sai kỳ vọng | Bắt buộc `fromDate` và `toDate` |
| Thiếu chuẩn lỗi | Consumer khó handle | Dùng `application/problem+json` |
