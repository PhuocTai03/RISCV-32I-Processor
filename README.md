# Thiết kế vi xử lý RISCV 32I single cycle
- Mỗi chu kì xung clock tích cực cạnh lên, vi xử lý này sẽ hoàn thành một lệnh được chỉ định từ thanh ghi PC.
- Thiết kế gồm 3 module lớn:
    - INSTRUCTION_FETCH: Truy xuất lệnh trong IMEM thông qua địa chỉ từ thanh ghi PC.
    - DATAPATH: gồm nhiều công đoạn thực thi lệnh như:
        - Giải mã lệnh thông qua Register Files 32 bit
        - Phân tích số tức thời (imm).
        - Tính toán kết quả qua bộ ALU.
        - Truy xuất bộ nhớ (đọc/ghi) bên trong DMEM.
        - Các bộ chọn MUX21, MUX31 để chọn đường tín hiệu phù hợp.
    - CONTROLLER: bộ phân tích mã lệnh để đưa ra các tín hiệu điều khiển phù hợp cho từng loại lệnh như I-type, R-type, B-type, ...
- Mô hình thiết kế RISCV-32I single-cycle:
![github](https://github.com/PhuocTai03/RISCV-32I-Processor/blob/main/media/singleCycle.png)
# Thiết kế vi xử lý RISCV 32I pipeline
- Mỗi chu kì xung clock tích cực cạnh lên, vi xử lý sẽ thực thi từng công đoạn một. Do đó, trong một chu kì xung clock có thể có nhiều lệnh thực thi cùng một lúc ở những công đoạn khác nhau.
- Các công đoạn cụ thể như sau:
    - IF: nạp lệnh từ bộ nhớ.
    - ID: giải mã lệnh và đọc các thanh ghi cần thiết.
    - EX: thực thi các phép tính hoặc tính toán địa chỉ.
    - MA: truy xuất các toán hạng trong bộ nhớ.
    - WB: ghi kết quả cuối vào thanh ghi.
- Mô hình thiết kế RISCV-32I pipeline:
![github](https://github.com/PhuocTai03/RISCV-32I-Processor/blob/main/media/pipeline.png)
- Các vấn đề xử lý xung đột (hazard)
    - Data hazard: một lệnh không thể thực thi theo đúng chu kì bởi lệnh này cần một số dữ liệu nào đó chưa sẵn sàng (chưa xác định), ví dụ:
        - lw    x2, 2(x4)       # x2 được lưu lại ở chu kì 5
        - add   x5, x1, x2      # x2 được đọc cần chu kì 3
    - Control hazard: chúng ta không biết lệnh nào sẽ được thực thi tiếp theo, ví dụ:
        - beq   x3, x2, -24     # lệnh tiếp theo được tính ở chu kì 3
        - add   x6, x5, x1      # lệnh được load ở chu kì 2
- Các phương pháp xử lý xung đột
    - Data hazard:
        - Forwarding (bypassing): dữ liệu cần sẽ được "forward" ngay khi có thể đến lệnh cần dữ liệu này. Phương pháp này đã được xử lý trong project.
            ![github](https://github.com/PhuocTai03/RISCV-32I-Processor/blob/main/media/forwarding.png)
        - Stalling: lệnh cần dữ liệu của lệnh trước sẽ được "pushed back" trong một hoặc vài chu kì. Chưa được xử lý trong project.
            ![github](https://github.com/PhuocTai03/RISCV-32I-Processor/blob/main/media/stalling.png)
    - Control hazard:
        - Chèn 2 lệnh nop (addi x0, x0, 0) ở phía sau lệnh nhảy (bỏ trống 2 chu kì). Project dùng phương pháp này để thay thế phương pháp branch prediction chưa được xử lý.
        - Assumed the branch wasn't taken:  tiếp tục xử lý các lệnh tiếp theo sau lệnh nhảy, nếu như lệnh nhảy được xác định thì các lệnh thực thi này sẽ bị xoá và không ảnh hưởng đến dữ liệu.
        - Dynamic branch prediction: tra cứu xem lệnh đã được thực hiện lần trước chưa. Nếu có, chúng ta sẽ dự đoán rằng lệnh nhảy sẽ được thực hiện lần nữa. Do đó sẽ chủ động chọn lệnh mà lệnh nhảy sẽ nhảy đến thay vì các lệnh tiếp theo sau lệnh nhảy.


