# ArkaFEM / PROMPT 05D — Scaling/Performance and v0.3.0 Gate

**این فایل فقط یک واحد کاری است.** فقط با دستور صریح کاربر اجرا شود. مبنا: آخرین **ZIP کامل ArkaFEM** و تمامی فایل‌های `00_READ_FIRST`, `CONTRACTS`, `REFERENCES`. تاریخچه و کدهای مرحله قبل را حفظ کن. اگر ZIP ورودی موجود نیست، ادامه را از روی حدس نساز.

**در تمام مراحل الزامی:** MATLAB R2024b+ هدف سازگاری (فقط بعد از آزمون تأیید)، SI، `arka` namespace، sparse، نظام DOF، تفکیک Material/Section/Element، قرارداد عددی Logan، تست منفی، Makefile با دستورات Git، مستندسازی روابط و مثال‌ها، status دوگانه implemented/verified. هیچ کد آینده‌ای را بدون تست runnable نام نبر. قراردادهای Master Prompt را کاملاً اجرا کن.

## هدف این برش
Benchmark sparse assembly and solver memory/time across increasing model sizes; collect reproducible environment metadata.

## تسک‌های دقیق اجرایی
1. Benchmark sparse assembly and solver memory/time across increasing model sizes; collect reproducible environment metadata.
2. Audit material and section catalog support: introduce I/Channel/T/Angle/Tube shape derivations only when separately validated; otherwise keep planned.
3. Review load combinations/modal API stability, regression full suite and v0.3.0 release eligibility.

## حداقل آزمون پذیرش
1. Runtime and nnz(K), deterministic ordering, result checks; compare sparse vs dense within safe sizes.
2. No unsupported precision/performance claims; full ZIP and handoff.

## فایل‌های اسناد که باید ایجاد/به‌روزرسانی شوند
- `docs/PERFORMANCE.md`
- `docs/VALIDATION_REPORT_0.3.md`
- `docs/sections/section_catalog.md`
در صورت تغییر فرمول یا مدل، سند `docs/theory` با روابط LaTeX، فرضیات، DOF، ترتیب محور، واحد، علامت، مثال دستیِ محاسبه‌شده، مشخصات ورودی، خروجی و مسیر تست ساخته شود؛ استاندارد `TEMPLATES/DOC_FORMULA_TEMPLATE.md` الزامی است. `docs/STATUS.md`, `docs/HANDOFF.md`, `docs/progress.json`, `CHANGELOG.md` و `README.md` بر اساس تغییرات واقعی همواره آپدیت شوند.

## خروجی و شرط توقف
**یک ZIP کامل** شامل ریشه `ArkaFEM/`, سورس کامل تا این نقطه، `Makefile` معتبر با Git helpers، `.gitignore`, `scripts`, `tests`, `examples`, `docs`, `README`, `CHANGELOG`, `VERSION`; فایل manifest/checksum و گزارش تست واقعی. کدِ این برش فقط در صورت PASS آزمون مربوط «verified» است؛ عدم وجود MATLAB باید **NOT_RUN** ثبت شود. از اعداد ساختگی پیشرفت یا Test PASS خودداری کن. دستورهای `make git-status`, `make git-diff`, `make git-stage`, `make git-commit MSG="..."` را پیشنهاد بده، ولی **خودت Commit/Push/Tag نکن**. در انتها Stage/Overall implemented و verified و باقی‌مانده و فایل پرامپت بعدی را گزارش کن و **متوقف شو**.


**قدم بعدی (فقط با تأیید کاربر):** `06A` — نام فایل دقیق در فهرست PROMPTS است.
