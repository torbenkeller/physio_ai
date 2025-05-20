-- Add access_token column to profiles table
ALTER TABLE profiles
    ADD COLUMN access_token UUID NOT NULL DEFAULT gen_random_uuid();