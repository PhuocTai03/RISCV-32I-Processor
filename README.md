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
# Thiết kế vi xử lý RISCV 32I pipeline (đang cập nhật ...)
- Mỗi chu kì xung clock tích cực cạnh lên, vi xử lý sẽ thực thi từng công đoạn một. Do đó, trong một chu kì xung clock có thể có nhiều lệnh thực thi cùng một lúc ở những công đoạn khác nhau.
- Các công đoạn cụ thể như sau:
    - IF: nạp lệnh từ bộ nhớ.
    - ID: giải mã lệnh và đọc các thanh ghi cần thiết.
    - EX: thực thi các phép tính hoặc tính toán địa chỉ.
    - MA: truy xuất các toán hạng trong bộ nhớ.
    - WB: ghi kết quả cuối vào thanh ghi.
- Mô hình thiết kế RISCV-32I pipeline:
![github](https://github.com/PhuocTai03/RISCV-32I-Processor/blob/main/media/pipeLine.png)



