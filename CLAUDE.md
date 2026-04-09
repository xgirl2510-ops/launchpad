# CLAUDE.md - Launchpad

## Tổng quan dự án

Launchpad là một công cụ mã nguồn mở giúp khởi tạo môi trường AI-first cho các dự án sử dụng Claude Code. Công cụ tự động thiết lập cấu trúc thư mục, cài đặt skills, tạo agents, và cấu hình rules phù hợp với từng loại dự án.

## Kiến trúc

- `src/interview/` - Giai đoạn 1: Thu thập thông tin dự án qua bộ câu hỏi
- `src/blueprint/` - Giai đoạn 2: Tạo kế hoạch thiết lập từ câu trả lời
- `src/modules/` - Giai đoạn 4: Các module thực thi (repo, settings, skills, agents, v.v.)
- `src/verify/` - Giai đoạn 5: Kiểm tra sức khỏe hệ thống sau thiết lập
- `presets/` - Các bộ cài đặt sẵn theo loại dự án (unity-game, saas-web, api-service, v.v.)
- `registry/` - Bản đồ nguồn bên ngoài cho skills, agents, tools

## Quy tắc phát triển

### Language

- **Code** (variables, functions, classes, commit messages): English
- **Inline comments**: English
- **User-facing docs and .md files**: Default to English. Detect the user's communication language and match it. If the user communicates in Vietnamese, write user-facing content in Vietnamese with full diacritics (dấu đầy đủ)
- **No em-dash** (`—`). Use hyphen (`-`) instead
- **No abbreviations** in user-facing text. Write out full words

### Code conventions

- Sử dụng ESM modules (`import`/`export`), không dùng CommonJS (`require`/`module.exports`)
- Tuân thủ YAGNI / KISS / DRY
- Giữ mỗi file dưới 200 dòng code
- Đặt tên file theo kebab-case với tên mô tả rõ ràng mục đích
- Tất cả presets phải có: `preset.json`, `skills.json`, `agents.json`

### Cấu trúc dự án

```
launchpad/
├── .claude/           - Cấu hình Claude Code cho dự án Launchpad
├── src/
│   ├── interview/     - Thu thập thông tin dự án
│   ├── blueprint/     - Tạo kế hoạch thiết lập
│   ├── modules/       - Các module thực thi
│   └── verify/        - Kiểm tra sau thiết lập
├── presets/            - Bộ cài đặt sẵn theo loại dự án
├── registry/           - Bản đồ nguồn bên ngoài
├── docs/               - Tài liệu hướng dẫn
└── plans/              - Kế hoạch phát triển
```

### Quy trình làm việc

1. Đọc file này trước khi bắt đầu bất kỳ tác vụ nào
2. Kiểm tra cấu trúc hiện tại trước khi tạo file mới
3. Chạy lệnh kiểm tra lỗi sau khi tạo hoặc chỉnh sửa file code
4. Không tạo file mới khi có thể chỉnh sửa file hiện có
5. Commit messages viết bằng tiếng Anh, theo conventional commit format
