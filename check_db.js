const postgres = require('postgres')

async function checkDbConnection() {
    try {
        

        const sql = postgres(process.env.DATABASE_URL, { 
          idle_timeout: 5 
        })
        const result = await sql`SELECT 1 + 1 AS solution`;
        console.log(`Database connection successful: ${result[0].solution}`);
        await sql.end();
        process.exit(0);
    } catch (error) {
        console.error(`Database connection failed: ${error.message}`);
        process.exit(1)
    }
}

checkDbConnection();
