from langchain_google_genai import ChatGoogleGenerativeAI
from langchain.prompts import ChatPromptTemplate
from langchain.schema.output_parser import StrOutputParser

def main():

    llm = ChatGoogleGenerativeAI(
        model="gemini-2.5-flash",
        google_api_key="API_KEY",
        temperature=0.9
    )

    prompt = ChatPromptTemplate.from_messages([
        ("system", "You are assitant"),
        ("human", "{question}")
    ])

    chain = prompt | llm | StrOutputParser()

    response = chain.invoke({ "question": "what is the capital of Sweden." })

    print(response)


if __name__ == "__main__":
    main()