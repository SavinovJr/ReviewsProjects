import Foundation
import CreateML

guard let trainingDataFileURL = Bundle.main.url(forResource: "amazon-reviews", withExtension:"json"), let testingDataFileURL = Bundle.main.url(forResource: "testing-reviews", withExtension: "json") else {
    fatalError("Error! Could not load resource files.")
}

do {
    let trainingDataTable = try MLDataTable(contentsOf: trainingDataFileURL)
    let testingDataTable = try MLDataTable(contentsOf: testingDataFileURL)

    let
    stats = """
    ==========================================

    Entries used for training: \(trainingDataTable.size)
    Entries used for testing: \(testingDataTable.size)

    """
    print (stats)

    let sentimentClassifier = try MLTextClassifier(trainingData: trainingDataTable, textColumn: "text", labelColumn: "label")

    let evaluationMetrics = sentimentClassifier.evaluation(on: testingDataTable)

    let trainingAccuracy = (1.0 - sentimentClassifier.trainingMetrics.classificationError ) * 100

    let validationAccuracy = (1.0 - sentimentClassifier.validationMetrics
        .classificationError) * 100

    let evaluationAccuracy = (1.0 - evaluationMetrics.classificationError) * 100

    let stats1 = """
    ==========================================

    Training accuracy: \(trainingAccuracy)

    Validating accuracy: \(validationAccuracy)

    Evaluation accurcy: \(evaluationAccuracy)

    """
    print(stats1)

    let modelFileURL = URL(fileURLWithPath:
        "/Users/antonsavinov/Documents/Projects/iOS/ReviewsProject/ReviewClassifier.mlmodel")

    let metadata = MLModelMetadata(author:
        "Anton Savinov", shortDescription:
        "A model trained to classify product review sentiment", version:
        "1.0")
    
    try sentimentClassifier.write(to: modelFileURL, metadata: metadata)

} catch {
    print(error.localizedDescription)
}
