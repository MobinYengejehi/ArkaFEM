# ArkaFEM / PROMPT 04C — Frame Releases, Offsets and Member Orientation

**این فایل فقط یک واحد کاری است.** فقط با دستور صریح کاربر اجرا شود. مبنا: آخرین **ZIP کامل ArkaFEM** و تمامی فایل‌های `00_READ_FIRST`, `CONTRACTS`, `REFERENCES`. تاریخچه و کدهای مرحله قبل را حفظ کن. اگر ZIP ورودی موجود نیست، ادامه را از روی حدس نساز.

**در تمام مراحل الزامی:** MATLAB R2024b+ هدف سازگاری (فقط بعد از آزمون تأیید)، SI، `arka` namespace، sparse، نظام DOF، تفکیک Material/Section/Element، قرارداد عددی Logan، تست منفی، Makefile با دستورات Git، مستندسازی روابط و مثال‌ها، status دوگانه implemented/verified. هیچ کد آینده‌ای را بدون تست runnable نام نبر. قراردادهای Master Prompt را کاملاً اجرا کن.

## هدف این برش
Implement end releases by mathematically justified static condensation or explicit support for released DOFs, with safe handling of mechanisms.

## تسک‌های دقیق اجرایی
1. Implement end releases by mathematically justified static condensation or explicit support for released DOFs, with safe handling of mechanisms.
2. Implement end rigid offsets/eccentricities using full displacement transformation, not only R matrix; allow controlled local-axis rotation.
3. Separate analysis modifiers from section base properties and avoid unintended double application.

## حداقل آزمون پذیرش
1. Pin-ended 2D/3D member reactions, pure offset consistency, release mechanism warnings and orientation regression.
2. Document transformation block matrix and effective load vector for release cases.

## فایل‌های اسناد که باید ایجاد/به‌روزرسانی شوند
- `docs/theory/frame_releases.md`
- `docs/theory/rigid_offsets.md`
- `docs/benchmarks/frame_releases.md`
در صورت تغییر فرمول یا مدل، سند `docs/theory` با روابط LaTeX، فرضیات، DOF، ترتیب محور، واحد، علامت، مثال دستیِ محاسبه‌شده، مشخصات ورودی، خروجی و مسیر تست ساخته شود؛ استاندارد `TEMPLATES/DOC_FORMULA_TEMPLATE.md` الزامی است. `docs/STATUS.md`, `docs/HANDOFF.md`, `docs/progress.json`, `CHANGELOG.md` و `README.md` بر اساس تغییرات واقعی همواره آپدیت شوند.

## خروجی و شرط توقف
**یک ZIP کامل** شامل ریشه `ArkaFEM/`, سورس کامل تا این نقطه، `Makefile` معتبر با Git helpers، `.gitignore`, `scripts`, `tests`, `examples`, `docs`, `README`, `CHANGELOG`, `VERSION`; فایل manifest/checksum و گزارش تست واقعی. کدِ این برش فقط در صورت PASS آزمون مربوط «verified» است؛ عدم وجود MATLAB باید **NOT_RUN** ثبت شود. از اعداد ساختگی پیشرفت یا Test PASS خودداری کن. دستورهای `make git-status`, `make git-diff`, `make git-stage`, `make git-commit MSG="..."` را پیشنهاد بده، ولی **خودت Commit/Push/Tag نکن**. در انتها Stage/Overall implemented و verified و باقی‌مانده و فایل پرامپت بعدی را گزارش کن و **متوقف شو**.


**قدم بعدی (فقط با تأیید کاربر):** `04D` — نام فایل دقیق در فهرست PROMPTS است.
