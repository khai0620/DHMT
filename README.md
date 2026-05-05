DHMT - Dự án Game 2D với Godot Engine
DHMT là một dự án phát triển game 2D chuyên sâu được xây dựng trên nền tảng Godot Engine. Đây là một bản mô phỏng các cơ chế trò chơi (game mechanics) cốt lõi, tập trung vào việc quản lý logic thông qua hệ thống Node và các kịch bản Resource tùy chỉnh. Dự án đóng vai trò như một môi trường thử nghiệm để triển khai các kỹ thuật xây dựng bản đồ (mapping) và xử lý tương tác vật lý trong không gian hai chiều.
Thông tin Kỹ thuật (Technical Stack)
Dưới đây là chi tiết các ngôn ngữ lập trình được sử dụng, dựa trên phân tích dữ liệu từ repository:
GDScript (99.3%): Ngôn ngữ chính dùng để điều khiển logic trò chơi, quản lý Scene instantiation và xử lý tín hiệu (signals) giữa các Node.
GDShader (0.7%): Được sử dụng để viết các mã nguồn Shader tùy chỉnh, phục vụ cho việc xử lý hiệu ứng hình ảnh (Visual Effects) hoặc vật liệu (Materials) đặc thù trong game.
Dự án được cấu hình và tối ưu hóa hoàn toàn cho môi trường Godot Engine (được xác nhận qua tệp cấu hình cốt lõi project.godot).
Cấu trúc Thư mục (Project Structure)
Hệ thống cây thư mục được tổ chức theo tiêu chuẩn của Godot để quản lý hiệu quả các Scene và Resource:
assets/: Chứa các tài nguyên đồ họa thô (Textures, Sprites) phục vụ giao diện và nhân vật.
scripts/: Nơi lưu trữ các tệp mã nguồn logic (.gd) được gắn vào các Node để điều khiển hành vi đối tượng.
sences/: Chứa các cảnh (Scenes) của game. Lưu ý kỹ thuật: Tên thư mục này hiện đang sử dụng định danh "sences" thay vì "scenes". Người dùng tuyệt đối không được đổi tên thư mục này để tránh làm gãy các đường dẫn nội bộ (internal paths) trong dự án.
tilesets/: Chứa các bộ gạch (TileSets) và cấu hình AutoTile để xây dựng môi trường bản đồ một cách nhanh chóng.
audio/: Lưu trữ các tệp âm thanh (Sound Effects) và nhạc nền (Background Music).
.vscode/ & .editorconfig: Các tệp cấu hình môi trường phát triển, cho thấy dự án đã được tối ưu hóa để làm việc tốt nhất trên trình soạn thảo Visual Studio Code.
Các tệp tin quan trọng tại thư mục gốc:
project.godot: Tệp cấu hình tổng thể của dự án (Project Settings), định nghĩa cửa sổ, lớp va chạm và các biến môi trường.
test_sence_map.tscn: Một tệp Text-based Scene (định dạng cảnh dưới dạng văn bản) đại diện cho bản đồ thử nghiệm, được sử dụng để kiểm tra việc instantiation các Node và Layout bản đồ.
Hướng dẫn Cài đặt & Sử dụng Cơ bản
Để thiết lập môi trường phát triển và chạy thử dự án DHMT, vui lòng thực hiện theo các bước sau:
Tải xuống mã nguồn hoặc sử dụng Git để Clone repository này về máy cục bộ.
Tải và cài đặt Godot Engine. Do cấu trúc dự án có thể tương thích với các phiên bản khác nhau, bạn nên kiểm tra tệp project.godot để xác định phiên bản chính xác hoặc sử dụng phiên bản Godot 4.x/3.x LTS mới nhất để đảm bảo tính ổn định.
Mở Godot Engine, nhấn vào nút "Import", điều hướng đến thư mục dự án và chọn tệp project.godot.
Sau khi giao diện biên tập mở ra, nhấn nút "Edit" để truy cập vào cây đối tượng (Node tree). Nhấn phím F5 (hoặc nút Play ở góc trên bên phải) để khởi chạy Scene mặc định và trải nghiệm game.
