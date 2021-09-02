module Deduplicator exposing (deduplicate)


deduplicate : List String -> List String
deduplicate words =
    List.foldl addToListIfNotMatch [] (List.sort words)

addToListIfNotMatch : String -> List String -> List String
addToListIfNotMatch element partialList =
    if Just element /= List.head partialList then
        element :: partialList

    else
        partialList

