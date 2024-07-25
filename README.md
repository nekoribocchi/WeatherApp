# Combineを使って天気アプリを作ってみた
こちらは実際に私がCombineを学習するにあたって作成してみたものになります。↓

![2](https://github.com/user-attachments/assets/9c112877-5c1b-4ac0-9ab8-a018a1ebee1a)

# Combineをさらっと復習
まずPublisherはデータを生成します。次にOperatorがそのデータをSubscriberが期待するデータの型に変換します。最後にSubscriberが最終的にそのデータを受け取って処理します。

![Combine-fig.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3812600/a6c6ff31-f57e-32ce-80c6-d8601df22dbd.png)

## 天気アプリの処理の流れ

天気アプリのWeatherFetcherクラスのfetchCities関数とfetchWeather関数についてご紹介します。
処理の流れは以下の通りで、どちらの関数でも同様の手順で進めています。

1. 関数のセットアップ
2. Publisherの生成
3. Operatorsの設定
4. Subscriberの設定



今回紹介するコードの例では、PublisherはAPIから取得したデータを発行し、Operatorはそのデータをフィルタリングや変換を行いながら、Subscriberが必要とする形式に整えます。最後に、Subscriberは整えられたデータを受け取る流れになります。


# WeatherFetcher

### fetchCities全体のコード
まずはfetchCities関数内のコードを見てみましょう。
```swift
//Combineフレームワークのデータを取得するための部分
    func fetchCities() {
        // 1. 関数のセットアップ
        let urlString = "https://weather.tsukumijima.net/primary_area.xml"
        guard let url = URL(string: urlString) else { return }
        
        // 2. Publisherの生成
        URLSession.shared.dataTaskPublisher(for: url)
        
        // 3. Operatorsの設定
            .map { $0.data }
            .tryMap { data -> [(String, String, String)] in
                let parser = XMLParser(data: data)
                let delegate = WeatherXMLParserDelegate()
                parser.delegate = delegate
                if parser.parse() {
                    return delegate.cities
                } else {
                    throw URLError(.badServerResponse)
                }
            }
            .receive(on: DispatchQueue.main)
        
        // 4. Subscriberの設定
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error: \(error)")
                }
            }, receiveValue: { [weak self] cities in
                self?.cities = cities
            })
            .store(in: &cancellables)
    
```
次にステップごとに上記のコードを解説していきます。
### 1. 関数のセットアップ

関数`fetchCities`を定義し、データを取得するためのURLを設定します。URLが正しくない場合、関数は何もせずに終了します。

```swift
let urlString = "https://weather.tsukumijima.net/primary_area.xml"
guard let url = URL(string: urlString) else { return }
```

### 2. Publisherの生成

`URLSession.shared.dataTaskPublisher(for: url)`を使って、指定したURLに対してHTTP GETリクエストを送信し、Publisherを生成します。このPublisherは、データとレスポンスを発行します。

```swift
URLSession.shared.dataTaskPublisher(for: url)
```

### 3. Operatorsの設定

Publisherに対して様々なOperatorsをチェーンさせてデータを処理します。

- `.map { $0.data }`: レスポンスの`data`部分のみを取り出します。この操作により、Publisherの型は`Data`になります。

```swift
.map { $0.data }
```

- `.tryMap { data -> [(String, String, String)] in`: 取得したデータをXML形式からタプルの配列に変換します。XMLParserを使用してパースし、成功した場合は`delegate.cities`を返し、失敗した場合はエラーをスローします。

```swift
.tryMap { data -> [(String, String, String)] in
    let parser = XMLParser(data: data)
    let delegate = WeatherXMLParserDelegate()
    parser.delegate = delegate
    if parser.parse() {
        return delegate.cities
    } else {
        throw URLError(.badServerResponse)
    }
}
```

- `.receive(on: DispatchQueue.main)`: メインスレッドで処理を受け取るようにします。これにより、UIの更新がメインスレッドで行われます。

```swift
.receive(on: DispatchQueue.main)
```

### 4. Subscriberの設定

Publisherから発行されたデータを受け取るためのSubscriberを設定します。

- `.sink(receiveCompletion:receiveValue:)`: データの受信と完了ステータスの処理を行います。`receiveCompletion`クロージャでは、リクエストの完了ステータスを受け取り、成功か失敗かを判定します。`receiveValue`クロージャでは、受信した値を処理します。

```swift
swiftコードをコピーする
.sink(receiveCompletion: { completion in
    if case .failure(let error) = completion {
        print("Error: \(error)")
    }
}, receiveValue: { [weak self] cities in
    self?.cities = cities
})
```

- `.store(in: &cancellables)`: 購読をキャンセル可能なセットに保持し、メモリリークを防ぎます。

```swift
.store(in: &cancellables)
```

# fetchWeather

### fetchWeather全体のコード

```swift
 func fetchWeather(for cityId: String, cityName: String) {
        selectedCityName = cityName
        let urlString = "https://weather.tsukumijima.net/api/forecast/city/\(cityId)"
        guard let url = URL(string: urlString) else {
            weatherInfo = "Invalid URL"
            weatherIcon = ""
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .map { response in
                (response.title, response.description.bodyText, response.forecasts.first?.telop ?? "")
            }
            .replaceError(with: ("Failed to fetch weather information.", "", ""))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                self?.weatherInfo = "\(result.1)"
                self?.weatherIcon = self?.iconForWeather(result.2) ?? ""
                self?.weatherIconColor = .white  // アイコンの色を設定
            }
            .store(in: &cancellables)
    }
```

### 1. 関数のセットアップ

```swift
selectedCityName = cityName
let urlString = "https://weather.tsukumijima.net/api/forecast/city/\(cityId)"
guard let url = URL(string: urlString) else {
    weatherInfo = "Invalid URL"
    weatherIcon = ""
    return
}
```

- `selectedCityName`に引数`cityName`を設定。
- `cityId`を用いてURL文字列を作成し、そのURLが有効かをチェックします。無効な場合はエラーメッセージを設定して関数を終了します。

### 2. Publisherの生成

```swift
URLSession.shared.dataTaskPublisher(for: url)
```

- `URLSession.shared.dataTaskPublisher(for: url)`は、指定されたURLに対してHTTPリクエストを送信し、レスポンスをPublisherとして発行します。

### 3. Operatorsの設定

```swift
.map { $0.data
```

- **`map` Operator**:
    - レスポンスからデータ部分（`data`）のみを抽出します。
    - `Publisher`の出力が`(data: Data, response: URLResponse)`から`Data`に変換されます。

```swift
.decode(type: WeatherResponse.self, decoder: JSONDecod
```

- **`decode` Operator**:
    - 受信したデータを`WeatherResponse`型にデコードします。
    - JSONデータを`WeatherResponse`というSwiftのデータモデルに変換します

```swift
.map { response in
    (response.title, response.description.bodyText, response.forecasts.first?.telop ?? "")

```

- **`map` Operator**:
    - デコードされた`WeatherResponse`をタプル`(String, String, String)`に変換します。
    - タプルの内容は`title`、`bodyText`、`telop`（天気予報のテキスト）です。

```swift
.replaceError(with: ("Failed to fetch weather information.", "", ""))
```

**`replaceError` Operator**:

- エラーが発生した場合に、指定した値`("Failed to fetch weather information.", "", "")`に置き換えます。

```swift
.receive(on: DispatchQueue.main)
```

- **`receive(on:)` Operator**:
    - メインスレッドで処理を受け取ります。UIの更新はメインスレッドで行う必要があるためです。

### 4. Subscriberの設定

```swift
.sink { [weak self] result in
    self?.weatherInfo = "\(result.1)"
    self?.weatherIcon = self?.iconForWeather(result.2) ?? ""
    self?.weatherIconColor = .white
}
```

- **`sink` Operator**:
    - 受信したデータを処理し、UIを更新します。
    - `receiveCompletion`クロージャは省略されており、成功時とエラー時の処理が統一されています。
    - `receiveValue`クロージャで受信した値を用いて、`weatherInfo`、`weatherIcon`、`weatherIconColor`を更新します。
