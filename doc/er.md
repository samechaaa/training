```mermaid
erDiagram
    Task {
        string title
        string description
        status status
        datetime expiredDate
        datetime createdDate
        priority priority
    }

    Category {
        string name
        string color
    }

    Status {
        string name
    }

    Priority {
        string name
    }

    Category 1 to zero or more Task : "has"
    Status 1 to zero or more Task : "has"
    Priority 1 to zero or more Task : "has"
```