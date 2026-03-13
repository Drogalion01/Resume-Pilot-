void main() { const env = String.fromEnvironment('API_BASE_URL', defaultValue: 'default'); print('ENV: >$env<'); }
