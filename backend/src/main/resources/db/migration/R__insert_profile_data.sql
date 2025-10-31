-- Insert profile data for the physiotherapy practice
INSERT INTO profiles (id, praxis_name, inhaber_name, profile_picture_url, access_token, version)
VALUES ('d7e8f9a0-b1c2-3d4e-5f6a-7b8c9d0e1f2a', 'Privatpraxis Carsten Huffmeyer', 'Carsten Huffmeyer', NULL,
        '5a6b7c8d-9e0f-1a2b-3c4d-5e6f7a8b9c0d', 1)
ON CONFLICT DO NOTHING;