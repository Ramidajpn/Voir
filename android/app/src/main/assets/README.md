# Model Placement Instructions

## วิธีการวางไฟล์ Model

1. นำไฟล์ `model_mobile.ptl` ของคุณมาวางไว้ในโฟลเดอร์นี้:
   ```
   android/app/src/main/assets/model_mobile.ptl
   ```

2. ตรวจสอบว่าชื่อไฟล์ตรงกับที่ระบุใน `ColorCorrectionAI.kt`:
   - ชื่อไฟล์: `model_mobile.ptl`
   - Input size: 224x224 pixels

## Model Requirements

- **Format**: PyTorch Lite (.ptl)
- **Input**: [1, 3, 224, 224] - RGB image normalized with ImageNet mean/std
- **Output**: [1, 3, 224, 224] - Color-corrected RGB image
- **Normalization**:
  - Mean: [0.485, 0.456, 0.406]
  - Std: [0.229, 0.224, 0.225]

## หมายเหตุ

หากโมเดลของคุณมี input/output format ต่างจากนี้ 
ให้แก้ไขค่าใน `ColorCorrectionAI.kt`:
- `INPUT_SIZE` - ขนาด input ของโมเดล
- `meanRGB` / `stdRGB` - ค่า normalization
