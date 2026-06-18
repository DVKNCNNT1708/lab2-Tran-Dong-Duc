# Biên bản đàm phán hợp đồng API

- Cặp đàm phán: Analytics Service ↔ Operator Portal
- Product: Smart Campus
- Provider: Analytics Service
- Consumer: Operator Portal
- Phiên: v1.0
- Ngày: 2026-05-12

---

## Issue #1

- Raised by: Consumer
- Endpoint: `POST /ingest`
- Concern: Payload đầu vào có nhiều nguồn dữ liệu nên dễ lệch field name giữa các team.
- Proposal: Chốt `sourceType` làm discriminator, chỉ cho phép `access` và `iot`.
- Resolution: Accepted.
- Rationale: Discriminator rõ ràng giúp Prism và Consumer parse ổn định.
- Impact: Provider phải giữ schema chặt, không được thêm field ngoài hợp đồng.

---

## Issue #2

- Raised by: Provider
- Endpoint: `POST /ingest`
- Concern: Event retry có thể gây gửi trùng.
- Proposal: Bắt buộc `eventId` và `correlationId` nullable để cho phép idempotent processing.
- Resolution: Modified.
- Rationale: `eventId` là bắt buộc, `correlationId` là tùy chọn nhưng khuyến nghị có khi upstream hỗ trợ.
- Impact: Consumer phải dùng `eventId` để chống xử lý lặp.

---

## Issue #3

- Raised by: Consumer
- Endpoint: `GET /analytics/summary`
- Concern: Khoảng thời gian tổng hợp cần ổn định để vẽ biểu đồ.
- Proposal: Bắt buộc `fromDate` và `toDate`, thêm `granularity` là `hour`, `day`, hoặc `week`.
- Resolution: Accepted.
- Rationale: Dashboard chỉ cần các mức tổng hợp này trong Lab 02.
- Impact: Response summary phải phản ánh đúng window đã yêu cầu.

---

## Issue #4

- Raised by: Provider
- Endpoint: `GET /dashboard`
- Concern: Dữ liệu dashboard thay đổi theo màn hình, nếu không giới hạn sẽ khó mock.
- Proposal: Trả về `cards` chuẩn hóa và `note` nullable cho thông báo phụ.
- Resolution: Accepted.
- Rationale: Dạng card đủ dùng cho mock server, không khóa thiết kế UI quá sớm.
- Impact: Consumer chỉ phụ thuộc vào cấu trúc card, không phụ thuộc layout cụ thể.

---

## Issue #5

- Raised by: Consumer
- Endpoint: `POST /auth/login`
- Concern: Cần phân biệt user đăng nhập được nhưng không đủ quyền truy cập dashboard/report.
- Proposal: Login chỉ trả token; quyền cụ thể xử lý qua `401` và `403` ở endpoint protected.
- Resolution: Accepted.
- Rationale: Tách auth và authorization giúp hợp đồng rõ ràng hơn.
- Impact: Consumer phải handle lỗi bảo vệ tài nguyên ở từng endpoint.

---

## Issue #6

- Raised by: Provider
- Endpoint: `GET /reports/{id}`
- Concern: Report có thể chưa sẵn sàng ngay sau khi tạo.
- Proposal: Dùng `status` gồm `READY`, `PROCESSING`, `FAILED`, và cho phép `description`/`downloadUrl` nullable.
- Resolution: Modified.
- Rationale: `description` nullable là cần thiết, còn `downloadUrl` chỉ xuất hiện khi report đã sẵn sàng.
- Impact: Consumer phải render trạng thái theo `status` thay vì giả định report luôn sẵn sàng.

---

# Chốt hợp đồng v1.0

Provider sign-off: Đã ký  
Consumer sign-off: Đã ký  
Witness (GV/TA): Chưa ký  
Date: 2026-05-12

---

## Ghi chú warning nếu Spectral còn cảnh báo

| Warning | Lý do chấp nhận tạm thời | Kế hoạch sửa |
|---|---|---|
|  |  |  |
