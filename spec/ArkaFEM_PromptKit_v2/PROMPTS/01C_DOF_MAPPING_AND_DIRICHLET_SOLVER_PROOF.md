# ArkaFEM / PROMPT 01C — DOF Mapping and Dirichlet Solver Proof

**این فایل فقط یک واحد کاری است.** فقط با دستور صریح کاربر اجرا شود. مبنا: آخرین **ZIP کامل ArkaFEM** و تمامی فایل‌های `00_READ_FIRST`, `CONTRACTS`, `REFERENCES`. تاریخچه و کدهای مرحله قبل را حفظ کن. اگر ZIP ورودی موجود نیست، ادامه را از روی حدس نساز.

**در تمام مراحل الزامی:** MATLAB R2024b+ هدف سازگاری (فقط بعد از آزمون تأیید)، SI، `arka` namespace، sparse، نظام DOF، تفکیک Material/Section/Element، قرارداد عددی Logan، تست منفی، Makefile با دستورات Git، مستندسازی روابط و مثال‌ها، status دوگانه implemented/verified. هیچ کد آینده‌ای را بدون تست runnable نام نبر. قراردادهای Master Prompt را کاملاً اجرا کن.

## هدف این برش
Implement deterministic node-ID/DOF mapper for one family at a time (1D, 2D truss/frame, 3D truss/frame); no mixed-family active union yet.

## تسک‌های دقیق اجرایی
1. Implement deterministic node-ID/DOF mapper for one family at a time (1D, 2D truss/frame, 3D truss/frame); no mixed-family active union yet.
2. Implement pure numerical Dirichlet solver for supplied manual K,F,prescribed DOFs, including nonzero supports, Kff partitioning and reaction `R=K*U-F`.
3. Keep manually assembled example separate from future automated element assembly; report singular/invalid systems explicitly.

## حداقل آزمون پذیرش
1. Spring chain k1=1e6,k2=2e6,F3=3000,U1=0 -> [0;.003;.0045] m and R1=-3000N.
2. Negative: contradictory constraints, singular Kff, malformed K/F, nonfinite inputs and nonzero support settlement; normalized residual.

## فایل‌های اسناد که باید ایجاد/به‌روزرسانی شوند
- `docs/theory/dof_mapping.md`
- `docs/theory/dirichlet_partition.md`
- `docs/benchmarks/manual_spring_chain.md`
در صورت تغییر فرمول یا مدل، سند `docs/theory` با روابط LaTeX، فرضیات، DOF، ترتیب محور، واحد، علامت، مثال دستیِ محاسبه‌شده، مشخصات ورودی، خروجی و مسیر تست ساخته شود؛ استاندارد `TEMPLATES/DOC_FORMULA_TEMPLATE.md` الزامی است. `docs/STATUS.md`, `docs/HANDOFF.md`, `docs/progress.json`, `CHANGELOG.md` و `README.md` بر اساس تغییرات واقعی همواره آپدیت شوند.

## خروجی و شرط توقف
**یک ZIP کامل** شامل ریشه `ArkaFEM/`, سورس کامل تا این نقطه، `Makefile` معتبر با Git helpers، `.gitignore`, `scripts`, `tests`, `examples`, `docs`, `README`, `CHANGELOG`, `VERSION`; فایل manifest/checksum و گزارش تست واقعی. کدِ این برش فقط در صورت PASS آزمون مربوط «verified» است؛ عدم وجود MATLAB باید **NOT_RUN** ثبت شود. از اعداد ساختگی پیشرفت یا Test PASS خودداری کن. دستورهای `make git-status`, `make git-diff`, `make git-stage`, `make git-commit MSG="..."` را پیشنهاد بده، ولی **خودت Commit/Push/Tag نکن**. در انتها Stage/Overall implemented و verified و باقی‌مانده و فایل پرامپت بعدی را گزارش کن و **متوقف شو**.


**قدم بعدی (فقط با تأیید کاربر):** `01D` — نام فایل دقیق در فهرست PROMPTS است.
