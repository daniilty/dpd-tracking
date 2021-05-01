# Dpd tracking info parser

Install all required dependencies:
```bash
$ sh pre-install.sh
```

Set your tracking number in config
```bash
$ [vim,nano,etc...] config.json
```
```json
{
  "url": "https://www.dpd.ru/ols/trace2/standard.do2?method:search=",
  "tracking_number": "RU12345..."
}
```

Run your program 
```bash
$ ruby dpd.rb
```
