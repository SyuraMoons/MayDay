alter table public.profiles
  add column if not exists email text;

update public.profiles
set email = lower(login_id)
where email is null and login_id like '%@%';

alter table public.profiles
  alter column email set not null;

create unique index if not exists profiles_email_key
  on public.profiles (email);

alter table public.profiles
  drop constraint if exists profiles_login_id_key;

drop index if exists public.profiles_login_id_key;

alter table public.profiles
  drop column if exists login_id;
