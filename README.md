Dự án phát triển game 2D cơ bản trên nền tảng Godot Engine 4


GIỚI THIỆU CHUNG

DHMT là dự án mã nguồn mở tập trung vào việc xây dựng trải nghiệm game 2D tối ưu. Tận dụng sức mạnh của Godot Engine phiên bản 4.x, dự án hướng tới cấu trúc mã nguồn linh hoạt, hiệu suất cao và quy trình phát triển hiện đại, cung cấp nền tảng vững chắc cho việc mở rộng các tính năng gameplay phức tạp.
THÔNG SỐ KỸ THUẬT (TECHNOLOGIES)

Dự án được xây dựng trên hệ sinh thái Godot 4, tận dụng các cải tiến mới về hệ thống Tilemap và khả năng xử lý rendering 2D mạnh mẽ:
Godot 4.x: Engine chính, cung cấp môi trường phát triển tích hợp và hiệu năng vượt trội.
GDScript (99.3%): Ngôn ngữ lập trình hướng đối tượng chuyên dụng để xử lý logic game, đảm bảo tốc độ thực thi và khả năng bảo trì mã nguồn.
GDShader (0.7%): Sử dụng để xây dựng các hiệu ứng hình ảnh (visual effects) và xử lý đồ họa nâng cao trực tiếp trên GPU.


TÍNH NĂNG NỔI BẬT

World Building: Hệ thống xây dựng bản đồ linh hoạt dựa trên Tilemap.

Audio System: Tích hợp quản lý âm thanh môi trường và hiệu ứng tương tác.

Visual Enhancements: Sử dụng shader tùy chỉnh để tối ưu hóa trải nghiệm thị giác.

CẤU TRÚC THƯ MỤC (PROJECT STRUCTURE)

Cấu trúc dự án được tổ chức theo tiêu chuẩn để quản lý tài nguyên và mã nguồn một cách khoa học:

Thư mục/Tập tin

Mô tả chức năng

assets/

Lưu trữ tài nguyên đồ họa, sprites và các texture 2D.

audio/

Hệ thống quản lý tệp âm thanh, nhạc nền (BGM) và hiệu ứng (SFX).

scripts/

Chứa mã nguồn logic xử lý đối tượng và điều khiển game (.gd).

sences/

Lưu trữ các cảnh (scenes) của dự án. Lưu ý: Thư mục hiện đặt tên theo typo gốc là "sences".

tilesets/

Quản lý tài nguyên Tilemap và các bộ gạch nền dùng cho xây dựng bản đồ.

project.godot

Tệp cấu hình gốc: Quản lý Autoloads, Input Map, Render settings và các thiết lập toàn cục.

test_sence_map.tscn

Cảnh thử nghiệm môi trường bản đồ chính, nằm tại thư mục gốc của dự án.

.vscode/

Cấu hình môi trường phát triển (IDE) cho Visual Studio Code.

.editorconfig

Quy chuẩn định dạng mã nguồn đồng nhất cho đội ngũ cộng tác.

.gitattributes

Định nghĩa thuộc tính đường dẫn và xử lý tệp tin cho Git.

.gitignore

Danh sách loại trừ các tệp tạm và tài nguyên không cần thiết khỏi quản lý phiên bản.
  
icon.svg

Tệp biểu tượng (icon) mặc định của dự án Godot.


HƯỚNG DẪNCÀI ĐẶT (INSTALLATION)

Để thiết lập môi trường phát triển cục bộ, vui lòng thực hiện theo các bước sau:

Chuẩn bị: file game "baycho.exe" và khởi chạy.

GHI CHÚ PHÁT TRIỂN (DEVELOPMENT NOTES)
Với lịch sử hơn 64 commits, dự án hiện đang trong giai đoạn phát triển tích cực. Các nhà phát triển đóng góp mã nguồn bắt buộc phải tuân thủ quy chuẩn trong .editorconfig. Việc này không chỉ duy trì coding style đồng nhất mà còn giúp tránh các lỗi xung đột (conflict) không đáng có trong quá trình merge code và quản lý phiên bản.

