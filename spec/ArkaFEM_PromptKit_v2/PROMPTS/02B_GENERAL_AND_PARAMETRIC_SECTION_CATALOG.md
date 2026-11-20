# ArkaFEM / PROMPT 02B — General and Parametric Section Catalog

**این فایل فقط یک واحد کاری است.** فقط با دستور صریح کاربر اجرا شود. مبنا: آخرین **ZIP کامل ArkaFEM** و تمامی فایل‌های `00_READ_FIRST`, `CONTRACTS`, `REFERENCES`. تاریخچه و کدهای مرحله قبل را حفظ کن. اگر ZIP ورودی موجود نیست، ادامه را از روی حدس نساز.

**در تمام مراحل الزامی:** MATLAB R2024b+ هدف سازگاری (فقط بعد از آزمون تأیید)، SI، `arka` namespace، sparse، نظام DOF، تفکیک Material/Section/Element، قرارداد عددی Logan، تست منفی، Makefile با دستورات Git، مستندسازی روابط و مثال‌ها، status دوگانه implemented/verified. هیچ کد آینده‌ای را بدون تست runnable نام نبر. قراردادهای Master Prompt را کاملاً اجرا کن.

## هدف این برش
Implement General, Rectangle, Circle and Pipe section records, material references, A/Iy/Iz/J geometry with documented local axis conventions, validation and model revisions.

## تسک‌های دقیق اجرایی
1. Implement General, Rectangle, Circle and Pipe section records, material references, A/Iy/Iz/J geometry with documented local axis conventions, validation and model revisions.
2. Add section query/list API and modifiers schema (A,Iy,Iz,J,Asy,Asz; default 1); do not silently apply twice. Validate optional shear areas and lack of relevant torsion for trusses.
3. Clearly defer open-section torsion/channel/I/T etc until independently validated; never substitute polar second moment for J in noncircular sections.

## حداقل آزمون پذیرش
1. Rectangle b=.30,h=.50m -> A=.15 m²,Iy=.003125 m4,Iz=.001125 m4; circle/pipes analytical benchmark, invalid D<=2t.
2. Negative tests: missing material, bad dims, duplicate section, invalid modifier.

## فایل‌های اسناد که باید ایجاد/به‌روزرسانی شوند
- `docs/sections/section_catalog.md`
- `docs/theory/section_rectangle.md`
- `docs/theory/section_circle_pipe.md`
- `docs/benchmarks/section_rectangle.md`
در صورت تغییر فرمول یا مدل، سند `docs/theory` با روابط LaTeX، فرضیات، DOF، ترتیب محور، واحد، علامت، مثال دستیِ محاسبه‌شده، مشخصات ورودی، خروجی و مسیر تست ساخته شود؛ استاندارد `TEMPLATES/DOC_FORMULA_TEMPLATE.md` الزامی است. `docs/STATUS.md`, `docs/HANDOFF.md`, `docs/progress.json`, `CHANGELOG.md` و `README.md` بر اساس تغییرات واقعی همواره آپدیت شوند.

## خروجی و شرط توقف
**یک ZIP کامل** شامل ریشه `ArkaFEM/`, سورس کامل تا این نقطه، `Makefile` معتبر با Git helpers، `.gitignore`, `scripts`, `tests`, `examples`, `docs`, `README`, `CHANGELOG`, `VERSION`; فایل manifest/checksum و گزارش تست واقعی. کدِ این برش فقط در صورت PASS آزمون مربوط «verified» است؛ عدم وجود MATLAB باید **NOT_RUN** ثبت شود. از اعداد ساختگی پیشرفت یا Test PASS خودداری کن. دستورهای `make git-status`, `make git-diff`, `make git-stage`, `make git-commit MSG="..."` را پیشنهاد بده، ولی **خودت Commit/Push/Tag نکن**. در انتها Stage/Overall implemented و verified و باقی‌مانده و فایل پرامپت بعدی را گزارش کن و **متوقف شو**.


**قدم بعدی (فقط با تأیید کاربر):** `02C` — نام فایل دقیق در فهرست PROMPTS است.
