-- Insert profile data for the physiotherapy practice
INSERT INTO profiles (id, praxis_name, inhaber_name, profile_picture_url, version)
VALUES ('d7e8f9a0-b1c2-3d4e-5f6a-7b8c9d0e1f2a', 'Privatpraxis Carsten Huffmeyer', 'Carsten Huffmeyer', NULL, 0)
ON CONFLICT DO NOTHING;