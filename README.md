# StockObserver

SwiftUI and MVVM-based iOS application for viewing Yahoo Finance data through RapidAPI endpoints.

## Features

- Market list screen
- Stock/detail screen
- Search by name or symbol
- Auto-refresh every 8 seconds
- SwiftUI + MVVM, Errors handling
- Swift Structured Concurrency
- Protocol-based services
- DTO to domain mapping
- Handling of empty detail endpoint responses
- Light and Dark mode support 

## API Configuration

This project requires a RapidAPI key.

For security reasons, the real API key is not committed.

Setup:

1. Copy `StockObserver/Configs/Secrets.example.xcconfig`
2. Rename the copy to `Secrets.xcconfig` (remove next line: `#include? "Secrets.xcconfig"`) 
3. Replace `PUT_YOUR_RAPIDAPI_KEY_HERE` with your RapidAPI key

`Secrets.xcconfig` is ignored by git.

## API Note

The task specification using:

- `market/v2/get-summary` for the list screen
- `stock/v2/get-summary` for the detail screen

At the time of development, `stock/v2/get-summary` is marked as deprecated on RapidAPI and returns `204 No Content` for tested symbols such as `AMRN`, `AAPL`, `MSFT`, `TSLA`, `NVDA`, `AMZN`, `GOOGL`, and `META`.

The app still calls the required endpoint. If the response is empty, the detail screen gracefully falls back to displaying additional data already available from the `market/v2/get-summary` response.

## Screenshots:
<img width="660" height="1434" alt="IMG_2971" src="https://github.com/user-attachments/assets/0f56a85c-3e47-4aed-8235-307ab148bf3b" />
<img width="660" height="1434" alt="IMG_2970" src="https://github.com/user-attachments/assets/6a81d4df-5ba4-4171-aa5e-c4c0ee14898c" />
<img width="660" height="1434" alt="IMG_2969" src="https://github.com/user-attachments/assets/867cc427-b03d-41a0-bd33-03e8fe36bdc8" />
<img width="660" height="1434" alt="IMG_2972" src="https://github.com/user-attachments/assets/d21556e5-7993-4edc-8a9f-9cbb5b50f61b" />
<img width="660" height="1434" alt="IMG_2973" src="https://github.com/user-attachments/assets/81ecd3ab-9890-4ee3-b1ba-47d17c2a120d" />
<img width="660" height="1434" alt="IMG_2974" src="https://github.com/user-attachments/assets/4c19ffd6-2172-4112-928a-96979c16b7fd" />
<img width="660" height="1434" alt="IMG_2975" src="https://github.com/user-attachments/assets/fd599617-a65e-4b23-8bff-3ed07f3692fe" />
<img width="660" height="1434" alt="IMG_2977" src="https://github.com/user-attachments/assets/1acc8f11-c3b0-45cc-a168-9e76ecee35ed" />


