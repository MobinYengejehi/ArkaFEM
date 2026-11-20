# پیام پیشنهادی برای ارسال به ChatGPT/Agent توسعه‌دهنده

این ZIP، **Master Source of Truth پروژه ArkaFEM** برای توسعه مرحله‌ای MATLAB FEM است. فایل‌های زیر را **به همین ترتیب** بخوان:
1. `00_READ_FIRST/01_MASTER_AGENT_PROMPT_FA.md`
2. `CONTRACTS/PROJECT_CHARTER.md`, `MATERIALS_AND_SECTIONS.md`, `NUMERICAL_AND_DOC_POLICY.md`, `DEV_GIT_QA_STATUS.md`
3. `REFERENCES/ARCHITECTURE.md`, `NUMERICAL_CONTRACTS.md`, `STAGE01_PLAN.md`
4. `00_READ_FIRST/02_PROMPT_INDEX.md`

اکنون **فقط** `PROMPTS/01A_REPOSITORY_BOOTSTRAP.md` را اجرا کن. مخزن فعلی هنوز ممکن است سورس نداشته باشد. خروجی، ZIP کامل سورس به همراه `Makefile`, Git helper targets, docs کامل برای هر رابطه/benchmark، STATUS درصدی و QA evidence باشد؛ سپس متوقف شو. هیچ مرحله بعدی را شروع نکن. اگر MATLAB موجود نیست تست‌هایش را NOT_RUN گزارش کن. هر کد باید وابستگی‌ها، واحدها و محدودیت‌هایش را شفاف ثبت کند.
