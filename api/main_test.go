package api

import (
	mockdb "github.com/23nazaryan/simplebank/db/mock"
	"github.com/23nazaryan/simplebank/util"
	"github.com/gin-gonic/gin"
	_ "github.com/lib/pq"
	"github.com/stretchr/testify/require"
	"os"
	"testing"
	"time"
)

func newTestServer(t *testing.T, store *mockdb.MockStore) *Server {
	config := util.Config{
		TokenSymmetricKey:   util.RandomString(32),
		AccessTokenDuration: time.Minute,
	}

	server, err := NewServer(config, store)
	require.NoError(t, err)

	return server
}

func TestMain(m *testing.M) {
	gin.SetMode(gin.TestMode)
	os.Exit(m.Run())
}
