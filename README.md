# 📘 Microsoft App Tutor – LMS

A Learning Management System for the **Microsoft App College Prep Course** (8 modules, 8 weeks).

## Features

| Feature | Tutor | Student | Parent |
|---|---|---|---|
| View all students & progress | ✅ | — | — |
| Log learning sessions (60–90 min) | ✅ | — | — |
| Check off teacher checklist items | ✅ | — | — |
| Check off student checklist items | ✅ | ✅ | — |
| Create & grade assignments | ✅ | — | — |
| Submit assignments (Drive/OneDrive link) | — | ✅ | — |
| View own module progress | — | ✅ | — |
| View child's full progress report | — | — | ✅ |

---

## Setup (one time, ~15 minutes)

### Step 1 — Create Supabase project
1. Go to [supabase.com](https://supabase.com) → **New Project**
2. Choose a name (e.g. `lms-tutor`) and a strong database password
3. Wait for the project to be ready

### Step 2 — Run the database schema
1. In Supabase → **SQL Editor** → **New Query**
2. Copy the contents of `supabase/schema.sql` and paste it
3. Click **Run**

### Step 3 — Get your API keys
In Supabase → **Project Settings** → **API**:
- Copy `Project URL` → `NEXT_PUBLIC_SUPABASE_URL`
- Copy `anon public` key → `NEXT_PUBLIC_SUPABASE_ANON_KEY`
- Copy `service_role secret` key → `SUPABASE_SERVICE_ROLE_KEY` *(keep secret!)*

### Step 4 — Configure environment
```bash
cp .env.example .env.local
# Edit .env.local and paste your keys
```

Your `.env.local` should look like:
```
NEXT_PUBLIC_SUPABASE_URL=https://xxxxxxxxxxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJ...
SUPABASE_SERVICE_ROLE_KEY=eyJ...
```

### Step 5 — Create the tutor account
1. In Supabase → **Authentication** → **Users** → **Add User**
2. Enter your email and password
3. After creation, go to **SQL Editor** and run:
```sql
INSERT INTO profiles (id, name, role)
VALUES ('<your-user-id-from-auth>', 'Your Name', 'tutor');
```
Replace `<your-user-id-from-auth>` with the UUID from the Users table.

### Step 6 — Install and run
```bash
cd /Users/nataliusfillepmarani/Documents/LMS-Tutor
npm install
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) and log in as the tutor.

---

## Deploy to Vercel (free)

```bash
npm install -g vercel
vercel
```

Set the three environment variables in Vercel dashboard → Settings → Environment Variables.

---

## Workflow

### For each student:
1. **Tutor** logs in → Dashboard → **+ Add Student** → creates student account
2. Optionally adds a **Parent** account and links it to the student

### Each session (60–90 min):
1. **Tutor** → Dashboard → **Log a Session** → fill module, date, duration, notes
2. **Tutor** goes to student → module page → checks off **Teacher Checklist** items
3. **Student** logs in → module page → checks off **Student Checklist** items

### Assignments:
1. **Tutor** creates assignment in module page
2. **Student** submits Google Drive or OneDrive link
3. **Tutor** grades and adds feedback

### Parents:
- Log in any time to see real-time progress: sessions, checklist completion, grades

---

## Course Structure

| Module | Week | Topic |
|---|---|---|
| 1 | Week 1 | Digital Basics, Security, Printer & OneNote |
| 2 | Week 2 | Word Foundations – Academic Papers & Formatting |
| 3 | Week 3 | Excel Foundations – Data, Formulas & Charts |
| 4 | Week 4 | PowerPoint Essentials & Presentation Design |
| 5 | Week 5 | Advanced Word – Long Documents & Automation |
| 6 | Week 6 | Advanced Excel – Analysis & Modeling |
| 7 | Week 7 | Teams & OneNote – Collaboration |
| 8 | Week 8 | Integration, Automation & Final Portfolio |
