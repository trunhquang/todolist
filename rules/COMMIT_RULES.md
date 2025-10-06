# Commit Rules

## Nguyên tắc cốt lõi

- Mỗi nội dung trong commit message là 1 dòng, bắt đầu bằng dấu gạch đầu dòng "- ".
- Mỗi dòng mô tả 1 thay đổi độc lập, ngắn gọn, rõ nghĩa (≤ 100 ký tự).
- Viết ở dạng mệnh lệnh (imperative): "Thêm...", "Sửa...", "Xóa...", "Refactor...".
- Không gộp nhiều ý trong một dòng; tách ra thành nhiều dòng bắt đầu bằng "- ".
- Ngôn ngữ nhất quán (vi hoặc en), ưu tiên tiếng Việt cho dự án này.
- Không kèm log, ảnh chụp màn hình hoặc mô tả quá dài trong commit; đưa vào PR/MR.

## Cấu trúc đề xuất

- Dòng 1: Tiêu đề ngắn gọn (tuân thủ quy tắc trên, có thể là 1 dòng duy nhất)
- Dòng 2+: Các dòng bổ sung (nếu cần), mỗi dòng 1 ý, vẫn bắt đầu bằng "- "

Ví dụ:

- Thêm check mustChangePassword và route change-password vào post-login
- Ẩn route register ở release build, chỉ bật ở debug/dev
- Fix check companyId dùng trim().isEmpty để chặn chuỗi rỗng

## Đặt phạm vi (scope) tùy chọn

- Có thể thêm tiền tố phạm vi: [auth], [splash], [docs], [rules], [navigation]
- Ví dụ: 
- [auth] Thêm changePassword và clear mustChangePassword trong DB

## Liên kết issue/ticket (nếu có)

- Thêm tham chiếu cuối message (cùng dạng 1 dòng):
- Ref: #123

## Tần suất và kích thước commit

- Commit nhỏ, tập trung theo từng thay đổi logic/UI.
- Tránh commit khổng lồ pha trộn nhiều phần không liên quan.

## Template gợi ý (tự do áp dụng)

- <scope optional> Tiêu đề cô đọng (1 dòng)
- Ý 1 (nếu cần)
- Ý 2 (nếu cần)
- Ref: <link/issue> (nếu có)


