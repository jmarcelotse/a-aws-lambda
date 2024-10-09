export const handler = async (event) => {
    console.log("Received event:", event);

    try {
        const response = {
            statusCode: 200,
            body: JSON.stringify('Hello from Node.js Lambda!'),
        };
        return response;
    } catch (error) {
        console.error("Error processing event:", error);
        return {
            statusCode: 500,
            body: JSON.stringify('Internal Server Error'),
        };
    }
};
