-- Create guestbook table
CREATE TABLE IF NOT EXISTS public.guestbook (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255),
    message TEXT NOT NULL,
    approved BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger for updated_at
CREATE TRIGGER update_guestbook_updated_at 
    BEFORE UPDATE ON public.guestbook 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- Enable Row Level Security (RLS)
ALTER TABLE public.guestbook ENABLE ROW LEVEL SECURITY;

-- Create policy for public read access (approved messages only)
CREATE POLICY "Allow public read access to approved messages" 
    ON public.guestbook 
    FOR SELECT 
    USING (approved = true);

-- Create policy for public insert access
CREATE POLICY "Allow public insert access" 
    ON public.guestbook 
    FOR INSERT 
    WITH CHECK (true);

-- Create policy for authenticated users to manage all messages (optional)
-- Uncomment if you want to manage messages through Supabase dashboard
-- CREATE POLICY "Allow authenticated users to manage messages" 
--     ON public.guestbook 
--     FOR ALL 
--     TO authenticated 
--     USING (true);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_guestbook_created_at ON public.guestbook(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_guestbook_approved ON public.guestbook(approved);

-- Insert a sample message (optional)
-- INSERT INTO public.guestbook (name, email, message) 
-- VALUES ('Hajira Shariff', 'hajirashariff2005@gmail.com', 'Welcome to my guest book! Feel free to leave a message.');
