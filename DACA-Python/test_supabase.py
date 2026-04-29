from supabase import create_client
 
# Asenda oma Supabase andmetega (Connect > API Keys)
url = "https://mtpcyuemcbtdldoftnmo.supabase.co"
key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im10cGN5dWVtY2J0ZGxkb2Z0bm1vIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQzODIwNTYsImV4cCI6MjA4OTk1ODA1Nn0.ZV8lKEfpVoNjEB1p-D4LMPEvG4-vjt9ri22B_FTEjSs"
 
supabase = create_client(url, key)
 
# Asenda oma tabeli nimega (nt 'test_sales' või 'team_members')
response = supabase.table('team_members').select("*").execute()
 
print(f"Leitud ridu: {len(response.data)}")
for row in response.data:
    print(row)

