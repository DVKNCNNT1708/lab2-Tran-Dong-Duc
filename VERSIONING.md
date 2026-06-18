# Versioning Strategy

Version hiện tại: v1.0.0

## Quy tắc

- PATCH: sửa lỗi mô tả, ví dụ, hoặc wording không làm vỡ hợp đồng.
- MINOR: thêm field hoặc endpoint mới nhưng vẫn backward-compatible.
- MAJOR: thay đổi breaking như đổi kiểu field, đổi discriminator, hoặc bỏ endpoint.

## Áp dụng cho Lab 02

- `openapi.yaml` đang ở mốc v1.0.0 sau khi chốt đàm phán.
- Mọi thay đổi trong Lab 02 phải giữ compatibility với contract đã nộp.
- Nếu cần thêm API cho Lab 03, ưu tiên tăng MINOR và giữ schema cũ.