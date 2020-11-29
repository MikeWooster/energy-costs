# Energy Costs

Service to calculate a users best energy provider.

# Dockerfile

The dockerfile has been built in 2 stages. The first to get
dependencies and build the app. The second using a distroless
build with only the bare essentials to run the app.

The file can built and ran locally (exposing at port 8080) with:

```
docker build -t energycost .
docker run -p 8080:8080 -it energycost
```
