void main() {
  print(Uri.parse('https://example.com/api/v1/')
      .resolve('auth/login')
      .toString());
}
