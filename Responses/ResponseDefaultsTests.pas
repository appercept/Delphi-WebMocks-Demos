unit ResponseDefaultsTests;

interface

uses
  DUnitX.TestFramework,
  System.Net.HttpClient,
  WebMock;

type
  [TestFixture]
  TResponseDefaultsTests = class
  private
    Client: THTTPClient;
    WebMock: TWebMock;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure Response_WhenNotStubbed_HasStatusNotImplemented;
    [Test]
    procedure Response_WhenStubbedWithDefaults_HasStatusOK;
    [Test]
    procedure Response_WhenStubbedWithDefaults_HasEmptyBody;
    [Test]
    procedure Response_WhenStubbedWithDefaults_HasContentLengthOfZero;
    [Test]
    procedure Response_WhenStubbedWithDefaults_HasContentTypeOfPlainTextUTF8;
  end;

implementation

uses
  System.SysUtils;

procedure TResponseDefaultsTests.Response_WhenNotStubbed_HasStatusNotImplemented;
var
  LResponse: IHTTPResponse;
begin
  LResponse := Client.Get(WebMock.URLFor('/'));

  Assert.AreEqual(501, LResponse.StatusCode);
end;

procedure TResponseDefaultsTests.Response_WhenStubbedWithDefaults_HasEmptyBody;
var
  LResponse: IHTTPResponse;
begin
  WebMock.StubRequest('GET', '/');

  LResponse := Client.Get(WebMock.URLFor('/'));

  Assert.IsTrue(LResponse.ContentAsString.IsEmpty);
end;

procedure TResponseDefaultsTests.Response_WhenStubbedWithDefaults_HasContentLengthOfZero;
var
  LResponse: IHTTPResponse;
begin
  WebMock.StubRequest('GET', '/');

  LResponse := Client.Get(WebMock.URLFor('/'));

  Assert.AreEqual('0', LResponse.HeaderValue['content-length']);
end;

procedure TResponseDefaultsTests.Response_WhenStubbedWithDefaults_HasContentTypeOfPlainTextUTF8;
var
  LResponse: IHTTPResponse;
begin
  WebMock.StubRequest('GET', '/');

  LResponse := Client.Get(WebMock.URLFor('/'));

  Assert.AreEqual('text/plain; charset=utf-8', LResponse.HeaderValue['content-type']);
end;

procedure TResponseDefaultsTests.Response_WhenStubbedWithDefaults_HasStatusOK;
var
  LResponse: IHTTPResponse;
begin
  WebMock.StubRequest('GET', '/');

  LResponse := Client.Get(WebMock.URLFor('/'));

  Assert.AreEqual(200, LResponse.StatusCode);
end;

procedure TResponseDefaultsTests.Setup;
begin
  Client := THTTPClient.Create;
  WebMock := TWebMock.Create;
end;

procedure TResponseDefaultsTests.TearDown;
begin
  WebMock.Free;
  Client.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TResponseDefaultsTests);

end.
