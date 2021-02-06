unit BasicDemoTests;

interface

uses
  DUnitX.TestFramework,
  System.Net.HttpClient,
  WebMock;

type
  [TestFixture]
  TBasicDemoTests = class
  private
    Client: THTTPClient;
    WebMock: TWebMock;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure Get_WhenStubbed_ReturnsOK;
  end;

implementation

procedure TBasicDemoTests.Get_WhenStubbed_ReturnsOK;
var
  LResponse: IHTTPResponse;
begin
  // Arrange
  WebMock.StubRequest('GET', '/');

  // Act
  LResponse := Client.Get(WebMock.URLFor('/'));

  // Assert
  Assert.AreEqual(200, LResponse.StatusCode);
end;

procedure TBasicDemoTests.Setup;
begin
  Client := THTTPClient.Create;
  WebMock := TWebMock.Create;
end;

procedure TBasicDemoTests.TearDown;
begin
  WebMock.Free;
  Client.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TBasicDemoTests);

end.
