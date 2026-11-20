# ArkaFEM / PROMPT 01A — Repository, Makefile and Open-Source Foundation

**این فایل فقط یک واحد کاری است.** فقط با دستور صریح کاربر اجرا شود. مبنا: آخرین **ZIP کامل ArkaFEM** و تمامی فایل‌های `00_READ_FIRST`, `CONTRACTS`, `REFERENCES`. تاریخچه و کدهای مرحله قبل را حفظ کن. اگر ZIP ورودی موجود نیست، ادامه را از روی حدس نساز.

**در تمام مراحل الزامی:** MATLAB R2024b+ هدف سازگاری (فقط بعد از آزمون تأیید)، SI، `arka` namespace، sparse، نظام DOF، تفکیک Material/Section/Element، قرارداد عددی Logan، تست منفی، Makefile با دستورات Git، مستندسازی روابط و مثال‌ها، status دوگانه implemented/verified. هیچ کد آینده‌ای را بدون تست runnable نام نبر. قراردادهای Master Prompt را کاملاً اجرا کن.

## هدف این برش
Inspect baseline design ZIP, create ArkaFEM repo skeleton with src/+arka, tests, examples, scripts, docs, MATLAB Project metadata as feasible. Do not claim .prj verified without MATLAB.

## تسک‌های دقیق اجرایی
1. Inspect baseline design ZIP, create ArkaFEM repo skeleton with src/+arka, tests, examples, scripts, docs, MATLAB Project metadata as feasible. Do not claim .prj verified without MATLAB.
2. Install a real root Makefile from TEMPLATES/Makefile with Git targets; create meaningful .gitignore, README, VERSION, CHANGELOG, CONTRIBUTING, issue/PR guidance. License: if MIT not explicitly approved, mark proposed and use a TODO; do not misrepresent license as formally approved.
3. Implement `arka.version` and one minimal `smoke` script; ensure only src parent is added to MATLAB path. Put original contracts into docs, add docs/STATUS.md/HANDOFF.md/progress.json.

## حداقل آزمون پذیرش
1. Static tree and Makefile target lint where tools available; `make help` and `git` helpers inspect only; MATLAB smoke `which arka.version` if runtime present.
2. Every deliverable ZIP includes complete repo and Makefile. Verify ZIP integrity; do not auto git commit.

## فایل‌های اسناد که باید ایجاد/به‌روزرسانی شوند
- `docs/ARCHITECTURE.md`
- `docs/ROADMAP.md`
- `docs/adr/0001-foundation.md`
- `docs/HANDOFF.md`
در صورت تغییر فرمول یا مدل، سند `docs/theory` با روابط LaTeX، فرضیات، DOF، ترتیب محور، واحد، علامت، مثال دستیِ محاسبه‌شده، مشخصات ورودی، خروجی و مسیر تست ساخته شود؛ استاندارد `TEMPLATES/DOC_FORMULA_TEMPLATE.md` الزامی است. `docs/STATUS.md`, `docs/HANDOFF.md`, `docs/progress.json`, `CHANGELOG.md` و `README.md` بر اساس تغییرات واقعی همواره آپدیت شوند.

## خروجی و شرط توقف
**یک ZIP کامل** شامل ریشه `ArkaFEM/`, سورس کامل تا این نقطه، `Makefile` معتبر با Git helpers، `.gitignore`, `scripts`, `tests`, `examples`, `docs`, `README`, `CHANGELOG`, `VERSION`; فایل manifest/checksum و گزارش تست واقعی. کدِ این برش فقط در صورت PASS آزمون مربوط «verified» است؛ عدم وجود MATLAB باید **NOT_RUN** ثبت شود. از اعداد ساختگی پیشرفت یا Test PASS خودداری کن. دستورهای `make git-status`, `make git-diff`, `make git-stage`, `make git-commit MSG="..."` را پیشنهاد بده، ولی **خودت Commit/Push/Tag نکن**. در انتها Stage/Overall implemented و verified و باقی‌مانده و فایل پرامپت بعدی را گزارش کن و **متوقف شو**.


**قدم بعدی (فقط با تأیید کاربر):** `01B` — نام فایل دقیق در فهرست PROMPTS است.
