# ArkaFEM / PROMPT 03C — Euler–Bernoulli Beam and 2D Frame Elements

**این فایل فقط یک واحد کاری است.** فقط با دستور صریح کاربر اجرا شود. مبنا: آخرین **ZIP کامل ArkaFEM** و تمامی فایل‌های `00_READ_FIRST`, `CONTRACTS`, `REFERENCES`. تاریخچه و کدهای مرحله قبل را حفظ کن. اگر ZIP ورودی موجود نیست، ادامه را از روی حدس نساز.

**در تمام مراحل الزامی:** MATLAB R2024b+ هدف سازگاری (فقط بعد از آزمون تأیید)، SI، `arka` namespace، sparse، نظام DOF، تفکیک Material/Section/Element، قرارداد عددی Logan، تست منفی، Makefile با دستورات Git، مستندسازی روابط و مثال‌ها، status دوگانه implemented/verified. هیچ کد آینده‌ای را بدون تست runnable نام نبر. قراردادهای Master Prompt را کاملاً اجرا کن.

## هدف این برش
Implement 2D Euler–Bernoulli bending beam with [UY,RZ] local DOFs, axial+flexural 2D frame with [UX,UY,RZ] per node; correct 4x4/6x6 local K.

## تسک‌های دقیق اجرایی
1. Implement 2D Euler–Bernoulli bending beam with [UY,RZ] local DOFs, axial+flexural 2D frame with [UX,UY,RZ] per node; correct 4x4/6x6 local K.
2. Define local-axis rotation, optional uniform load as explicit feature only if validated; element end actions vs nodal loads `q_local = K_local*u_local - p_equiv_local`.
3. Integrate section A, Iz (2D XY bending about Z) with local Iy/Iz convention; ensure no accidental swap.

## حداقل آزمون پذیرش
1. Cantilever tip force: delta=PL^3/(3EI) and theta=PL^2/(2EI) under documented sign; frame reactions and local end moments.
2. Negative: bad section moment, zero length, unconstrained rotation, orientation reversal.

## فایل‌های اسناد که باید ایجاد/به‌روزرسانی شوند
- `docs/theory/element_beam_2d.md`
- `docs/theory/element_frame_2d.md`
- `docs/benchmarks/cantilever_2d.md`
در صورت تغییر فرمول یا مدل، سند `docs/theory` با روابط LaTeX، فرضیات، DOF، ترتیب محور، واحد، علامت، مثال دستیِ محاسبه‌شده، مشخصات ورودی، خروجی و مسیر تست ساخته شود؛ استاندارد `TEMPLATES/DOC_FORMULA_TEMPLATE.md` الزامی است. `docs/STATUS.md`, `docs/HANDOFF.md`, `docs/progress.json`, `CHANGELOG.md` و `README.md` بر اساس تغییرات واقعی همواره آپدیت شوند.

## خروجی و شرط توقف
**یک ZIP کامل** شامل ریشه `ArkaFEM/`, سورس کامل تا این نقطه، `Makefile` معتبر با Git helpers، `.gitignore`, `scripts`, `tests`, `examples`, `docs`, `README`, `CHANGELOG`, `VERSION`; فایل manifest/checksum و گزارش تست واقعی. کدِ این برش فقط در صورت PASS آزمون مربوط «verified» است؛ عدم وجود MATLAB باید **NOT_RUN** ثبت شود. از اعداد ساختگی پیشرفت یا Test PASS خودداری کن. دستورهای `make git-status`, `make git-diff`, `make git-stage`, `make git-commit MSG="..."` را پیشنهاد بده، ولی **خودت Commit/Push/Tag نکن**. در انتها Stage/Overall implemented و verified و باقی‌مانده و فایل پرامپت بعدی را گزارش کن و **متوقف شو**.


**قدم بعدی (فقط با تأیید کاربر):** `03D` — نام فایل دقیق در فهرست PROMPTS است.
